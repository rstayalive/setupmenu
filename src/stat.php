<?php
// db connection, you can get this params from file /etc/freepbx.conf
$username = 'freepbxuser';
$password = '';
$host = 'localhost';
$dbname = 'asteriskcdrdb';

// Create a new PDO instance
try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}

// Define the time range for statistics
$startDate = isset($_POST['start_date']) ? $_POST['start_date'] : date('Y-m-d 00:00:00', strtotime('-1 day'));
$endDate = isset($_POST['end_date']) ? $_POST['end_date'] : date('Y-m-d 23:59:59');

// Define column filters
$srcFilter = isset($_POST['src']) ? $_POST['src'] : '';
$dstFilter = isset($_POST['dst']) ? $_POST['dst'] : '';
$dispositionFilter = isset($_POST['disposition']) ? $_POST['disposition'] : '';

// Build the query with filters
$query = "SELECT calldate, duration, disposition, src, dst, recordingfile FROM cdr WHERE calldate BETWEEN :startDate AND :endDate";
$params = [':startDate' => $startDate, ':endDate' => $endDate];

if ($srcFilter) {
    $query .= " AND src LIKE :src";
    $params[':src'] = "%$srcFilter%";
}

if ($dstFilter) {
    $query .= " AND dst LIKE :dst";
    $params[':dst'] = "%$dstFilter%";
}

if ($dispositionFilter) {
    $query .= " AND disposition = :disposition";
    $params[':disposition'] = $dispositionFilter;
}

// Execute the query
$stmt = $pdo->prepare($query);
$stmt->execute($params);
$calls = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Function to determine if a number is an internal extension
function is_internal($number) {
    // Internal extensions have less than 5 digits
    return strlen($number) < 5;
}

// Function to determine if a call is incoming or outgoing
function get_call_type($src, $dst) {
    if (is_internal($src) && !is_internal($dst)) {
        return 'Outgoing';
    } elseif (!is_internal($src) && is_internal($dst)) {
        return 'Incoming';
    } else {
        return 'Internal';
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Call Statistics</title>
</head>
<body>
    <h1>Call Statistics</h1>
    <form method="post" action="">
        <label for="start_date">Start Date:</label>
        <input type="datetime-local" id="start_date" name="start_date" value="<?php echo date('Y-m-d\TH:i', strtotime($startDate)); ?>"><br><br>
        <label for="end_date">End Date:</label>
        <input type="datetime-local" id="end_date" name="end_date" value="<?php echo date('Y-m-d\TH:i', strtotime($endDate)); ?>"><br><br>
        <label for="src">Source:</label>
        <input type="text" id="src" name="src" value="<?php echo htmlspecialchars($srcFilter); ?>"><br><br>
        <label for="dst">Destination:</label>
        <input type="text" id="dst" name="dst" value="<?php echo htmlspecialchars($dstFilter); ?>"><br><br>
        <label for="disposition">Disposition:</label>
        <input type="text" id="disposition" name="disposition" value="<?php echo htmlspecialchars($dispositionFilter); ?>"><br><br>
        <input type="submit" value="Get Statistics">
    </form>

    <h2>Call Records (from <?php echo $startDate; ?> to <?php echo $endDate; ?>)</h2>
    <table border="1">
        <tr>
            <th>Call Date</th>
            <th>Duration</th>
            <th>Disposition</th>
            <th>Source</th>
            <th>Destination</th>
            <th>Type</th>
            <th>Recording</th>
        </tr>
        <?php foreach ($calls as $call): ?>
            <tr>
                <td><?php echo htmlspecialchars($call['calldate']); ?></td>
                <td><?php echo htmlspecialchars($call['duration']); ?></td>
                <td><?php echo htmlspecialchars($call['disposition']); ?></td>
                <td><?php echo htmlspecialchars($call['src']); ?></td>
                <td><?php echo htmlspecialchars($call['dst']); ?></td>
                <td><?php echo htmlspecialchars(get_call_type($call['src'], $call['dst'])); ?></td>
                <td>
                    <?php if ($call['recordingfile']): ?>
                        <a href="/admin/recordings/<?php echo htmlspecialchars($call['recordingfile']); ?>" target="_blank">Play</a> | 
                        <a href="/admin/recordings/<?php echo htmlspecialchars($call['recordingfile']); ?>" download>Download</a>
                    <?php else: ?>
                        No recording
                    <?php endif; ?>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
</body>
</html>

<?php
// Close the database connection
$pdo = null;
?>
