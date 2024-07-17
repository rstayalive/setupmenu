<?php
// MySQL connection
$link = mysqli_connect("localhost", "report", "2yCg6e8r5ng");
if (!$link) {
    die('Could not connect: ' . mysqli_error());
}
mysqli_select_db($link, "asteriskcdrdb");

$today = date('Y-m-d'); 
$data = date('d-m-Y H:i:s');
$email = "myemail@example.com"; // Replace with your email address

echo "NO ANSWERED ---------------------------------<br>";

// Query for NO ANSWERED calls
$result = mysqli_query($link, "SELECT DISTINCT src, calldate FROM cdr WHERE disposition = 'NO ANSWER' AND calldate >= '$today 00:00:00' AND calldate <= '$today 23:59:59' AND duration > 5 AND LENGTH(src) > 3;");
$counter = 0;
$noansw = [];
$calldate = [];

while ($row = mysqli_fetch_array($result, MYSQLI_NUM)) {
    $counter++;
    $noansw[$counter] = $row[0];
    $calldate[$counter] = $row[1];
    echo "{$noansw[$counter]}<br>";
}

echo "ANSWERED ---------------------------------<br>";

// Query for ANSWERED calls
$result = mysqli_query($link, "SELECT DISTINCT src, calldate FROM cdr WHERE disposition = 'ANSWERED' AND calldate >= '$today 00:00:00' AND calldate <= '$today 23:59:59' AND LENGTH(src) > 3;");
$counter = 0;
$answ = [];

while ($row = mysqli_fetch_array($result, MYSQLI_NUM)) {
    $counter++;
    $answ[$counter] = $row[0];
    echo "{$answ[$counter]}<br>";
}

echo "DELETE ANSWERED ---------------------------------<br>";

// Remove ANSWERED calls from NO ANSWERED list
$total1 = count($noansw);
$counter1 = 0;

foreach ($noansw as $key1 => $value1) {
    $counter1++;
    if ($counter1 <= $total1) {
        $total2 = count($answ);
        $counter2 = 0;
        foreach ($answ as $key2 => $value2) {
            $counter2++;
            if ($counter2 <= $total2) {
                if ($noansw[$counter1] == $answ[$counter2]) {
                    echo "delete {$noansw[$counter1]}<br>";
                    unset($noansw[$counter1]);
                }
            }
        }
    }
}

// Email setup
$headers = "Content-type: text/html; charset=utf-8 \r\n";
$headers .= "From: asterisk.maildelivery@gmail.com \r\n";
$headers .= "Reply-To: asterisk.maildelivery@gmail.com \r\n";

$mes = '<table style="max-width: 575px;border-bottom:none; margin: 0 auto;border-spacing: inherit;">
<thead>
<tr style="border-bottom: 2px solid #05477c;">
<th style="padding:10px; color: #fff; max-width: 150px;background:#05477c;">Порядковый номер</th>
<th style="padding:10px; color: #fff; max-width: 150px;background:#05477c;">Дата</th>
<th style="padding:10px; color: #fff; max-width: 100px;background:#05477c;">От кого</th>
</tr>
</thead>';

echo "RESULT ---------------------------------<br>";

// Display NO ANSWERED calls in HTML table
$counter3 = 0;

foreach ($noansw as $key => $value) {
    $counter3++;
    if (!empty($noansw[$key])) {
        echo "{$noansw[$key]}<br>";
        $mes .= '
        <tbody>
        <tr style="width: 100px;">
        <td style="padding:10px; border-bottom: 1px solid #eee; text-align:center;">' . $counter3 . '</td>
        <td style="padding:10px; border-bottom: 1px solid #eee; text-align:center; min-width: 100px;">' . $calldate[$key] . '</td>
        <td style="padding:10px; border-bottom: 1px solid #eee; text-align:center; min-width: 100px;">' . $noansw[$key] . '</td>
        </tr>
        </tbody>';
    }
}

// Send email if there are NO ANSWERED calls
if ($counter3 > 0) {
    mail($email, 'Пропущенные звонки за ' . $data, $mes, $headers);
    echo "No Answer Count = $counter3<br>";
} else {
    echo "Net No Answer<br>";
}

// Close MySQL connection
mysqli_close($link);
?>
