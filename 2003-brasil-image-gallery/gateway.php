<?php
    /*
        $Id: gateway.php,v 1.2 2003/03/12 22:28:01 ktukker Exp $
    */
    include("../flashservices/app/Gateway.php");

    // include for sourceforge mysql credentials
    //include_once("credentials.php");

    $gateway = new Gateway();
    $gateway->setBaseClassPath("./services/");
    $gateway->service();

?>