<?php
/***********************************************************************************************
 *                        --= Processmaker Web Entry Request handler =--                       *
 *                                                                                             *
 *             This file was autogenerated by Processmaker Open Source  Rel-{version}          *
 ***********************************************************************************************/

//@Dynaform  : {dynaform}
//@Workspace : {ws}
//@Timestamp : {timestamp}

define("WS_WSDL_URL",   "{wsdlUrl}");
define("WS_UPLOAD_URL", "{wsUploadUrl}");
define("WS_USER_ID",    "{wsUser}");
define("WS_USER_PASS",  "{wsPass}");
define("WS_ROUNDROBIN", "{wsRoundRobin}");

try {
    @include_once ("wsClient.php");

    if (!function_exists("ws_open")){
        throw (new Exception("function ws_open() is not defined. File wsClient.php is missing"));
    }

    /*
     * PMDynaform
     * DYN_VERSION is 1: classic Dynaform,
     * DYN_VERSION is 2: responsive form, Pmdynaform.
     */
    $a = new Criteria("workflow");
    $a->addSelectColumn(DynaformPeer::DYN_VERSION);
    $a->add(DynaformPeer::DYN_UID, "{dynaformUid}", Criteria::EQUAL);
    $a = ProcessPeer::doSelectRS($a);
    $a->setFetchmode(ResultSet::FETCHMODE_ASSOC);
    $a->next();
    $row = $a->getRow();
    $swpmdynaform = isset($row) && $row["DYN_VERSION"] == 2;
    if ($swpmdynaform) {
        $pmdynaform = $_POST["form"];
    }

    $oForm = new Form("{processUid}" . "/" . "{dynaformUid}", PATH_DYNAFORM);
    $oForm->validatePost();

    ws_open();
    if ($swpmdynaform) {
        $obj = new stdClass();
        $obj->name = "__POST_VARIABLES__";
        $obj->value = G::json_encode($pmdynaform);
        $result = ws_newCase("{processUid}", "{taskUid}", array($obj));
    } else {
      $result = ws_newCase("{processUid}", "{taskUid}", convertFormToWSObjects($_POST["form"]));
    }

    if ($result->status_code == 0) {
        $caseId = $result->caseId;
        $caseNr = $result->caseNumber;

        {USR_VAR}

        if ($USR_UID == -1) {
            G::LoadClass("sessions");

            global $sessionId;

            $sessions = new Sessions();
            $session  = $sessions->getSessionUser($sessionId);

            $USR_UID = $session["USR_UID"];
        }

        //Save files
        if (isset( $_FILES["form"]["name"] ) && count( $_FILES["form"]["name"] ) > 0) {
            $arrayField = array ();
            $arrayFileName = array ();
            $arrayFileTmpName = array ();
            $arrayFileError = array ();
            $i = 0;

                foreach ($_FILES["form"]["name"] as $fieldIndex => $fieldValue) {
                    if (is_array( $fieldValue )) {
                        foreach ($fieldValue as $index => $value) {
                            if (is_array( $value )) {
                                foreach ($value as $grdFieldIndex => $grdFieldValue) {
                                    $arrayField[$i]["grdName"] = $fieldIndex;
                                    $arrayField[$i]["grdFieldName"] = $grdFieldIndex;
                                    $arrayField[$i]["index"] = $index;

                                    $arrayFileName[$i] = $_FILES["form"]["name"][$fieldIndex][$index][$grdFieldIndex];
                                    $arrayFileTmpName[$i] = $_FILES["form"]["tmp_name"][$fieldIndex][$index][$grdFieldIndex];
                                    $arrayFileError[$i] = $_FILES["form"]["error"][$fieldIndex][$index][$grdFieldIndex];
                                    $i = $i + 1;
                            }
                        }
                    }
                    } else {
                        $arrayField[$i] = $fieldIndex;
                        $arrayFileName[$i] = $_FILES["form"]["name"][$fieldIndex];
                        $arrayFileTmpName[$i] = $_FILES["form"]["tmp_name"][$fieldIndex];
                        $arrayFileError[$i] = $_FILES["form"]["error"][$fieldIndex];
                        $i = $i + 1;
                    }
                }
                if (count( $arrayField ) > 0) {
                    for ($i = 0; $i <= count( $arrayField ) - 1; $i ++) {
                        if ($arrayFileError[$i] == 0) {
                            $indocUid = null;
                            $fieldName = null;
                            $fileSizeByField = 0;

                            if (is_array( $arrayField[$i] )) {
                                if (isset( $_POST["INPUTS"][$arrayField[$i]["grdName"]][$arrayField[$i]["grdFieldName"]] ) && ! empty( $_POST["INPUTS"][$arrayField[$i]["grdName"]][$arrayField[$i]["grdFieldName"]] )) {
                                    $indocUid = $_POST["INPUTS"][$arrayField[$i]["grdName"]][$arrayField[$i]["grdFieldName"]];
                                }

                                $fieldName = $arrayField[$i]["grdName"] . "_" . $arrayField[$i]["index"] . "_" . $arrayField[$i]["grdFieldName"];

                                if (isset($_FILES["form"]["size"][$arrayField[$i]["grdName"]][$arrayField[$i]["index"]][$arrayField[$i]["grdFieldName"]])) {
                                    $fileSizeByField = $_FILES["form"]["size"][$arrayField[$i]["grdName"]][$arrayField[$i]["index"]][$arrayField[$i]["grdFieldName"]];
                                }
                            } else {
                                if (isset( $_POST["INPUTS"][$arrayField[$i]] ) && ! empty( $_POST["INPUTS"][$arrayField[$i]] )) {
                                $indocUid = $_POST["INPUTS"][$arrayField[$i]];
                            }

                            $fieldName = $arrayField[$i];

                            if (isset($_FILES["form"]["size"][$fieldName])) {
                                $fileSizeByField = $_FILES["form"]["size"][$fieldName];
                            }
                        }

                        $temDir = G::sys_get_temp_dir();
                        $uploadfile = $temDir . PATH_SEP . basename($arrayFileName[$i]);
                        $result = move_uploaded_file($arrayFileTmpName[$i], $uploadfile);

                        $filePath = $temDir . PATH_SEP . $arrayFileName[$i];
                        file_put_contents($filePath, file_get_contents($uploadfile));
                        $filename = $arrayFileName[$i];

                        if ($indocUid != null) {
                            //Input file type
                            ws_sendFile($uploadfile, $USR_UID, $caseId, 1, $indocUid, $fieldName, null, null, $filename);
                        } else {
                            //Attached file type
                            ws_sendFile($uploadfile, $USR_UID, $caseId, 1, null, $fieldName, null, null, $filename);
                        }
                    }
                }
            }
        }

        $result = ws_routeCase($caseId, 1);
        $assign = $result->message;

        $aMessage["MESSAGE"] = "<br />Case created in ProcessMaker<br />Case Number: $caseNr <br />Case Id: $caseId<br />Case derivated to: $assign";
    } else {
        $aMessage["MESSAGE"] = "<font color=\"red\">
                                An error occurred while the application was being processed.<br />
                                Error code: " . $result->status_code . "<br />
                                Error message: " . $result->message . "
                                </font>
                                <br /><br />
                                <strong>Please contact to your system administrator.</strong>";
    }

    /**
    * By default show the case info, for the recently created case
    * you can change it or redirect to another page
    * i.e. G::header("Location: http://www.processmaker.com");
    */
	/*----------------------------------********---------------------------------*/
    $G_PUBLISH = new Publisher();
    $G_PUBLISH->AddContent("xmlform", "xmlform", "login/showInfo", "", $aMessage);
    G::RenderPage("publish", "blank");
} catch (Exception $e) {
    $G_PUBLISH = new Publisher();
    $suggest_message = "This web entry should be regenerated, please contact to your system administrator.";
    $aMessage["MESSAGE"] = "<font color=\"red\"><pre>" . $e->getMessage() . "</pre>" . $suggest_message . "</font>";
    $G_PUBLISH->AddContent("xmlform", "xmlform", "login/showMessage", "", $aMessage);
    G::RenderPage("publish", "blank");
}