<?php
if($argc < 2){
    echo '请输入项目名称';
    echo "<\br>";
    return;
}

//随机拼接字符
function getSaltStr() 
{
    //随机长度
    $count = rand(10,15);
    //默认值(!),从33-126(!-~)排除(" / \)等需要转义的字符
    $temp = 33;
    $appendStr = '';
    for($i = 0; $i < $count; ++$i)
    {
        while (1)
        {
            $temp = rand(33,126);
            if(($temp != 34) && ($temp != 36) && ($temp != 47) && ($temp != 92)) break;
        }
        $appendStr .= chr($temp);
    }
    return $appendStr;
}

$phpString = "[";
$iosString = "@[";
$javaString = "[";
for($i = 0; $i < 100; ++$i)
{
    $phpString = $phpString . "\"" . getSaltStr() . "\",";
    $iosString = $iosString . "@\"" . getSaltStr() . "\",";
}
$phpString = substr($phpString,0,strlen($phpString) - 1);
$iosString = substr($iosString,0,strlen($iosString) - 1);
$phpString = $phpString . "]";
$iosString = $iosString . "]";
$javaString = $phpString;

//输出文本信息

//iOS
file_put_contents($argv[1].'_iOS_'.'Key.json',$iosString);

//PHP
$str = "<?php\n return " . $phpString . ";";
file_put_contents($argv[1].'_PHP_'.'Key.php',$str);

//Java
file_put_contents($argv[1].'_Java_'.'Key.php',$javaString);

echo("***important:请到当前脚本执行路径下拷贝文件!\n");