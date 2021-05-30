TYPE=TRIGGERS
triggers='CREATE DEFINER=`bn_processmaker`@`127.0.0.1` TRIGGER SUB_APPLICATION_INSERT BEFORE INSERT ON SUB_APPLICATION\nFOR EACH ROW\nBEGIN\n    DECLARE PREVIOUS_USR_UID VARCHAR(32);\n\n    SET @PREVIOUS_USR_UID = \'\';\n\n    SET @PREVIOUS_USR_UID = (\n        SELECT APPDEL2.USR_UID\n        FROM   APP_DELEGATION AS APPDEL1, APP_DELEGATION AS APPDEL2\n        WHERE  APPDEL1.APP_UID = NEW.APP_PARENT AND APPDEL1.DEL_INDEX = NEW.DEL_INDEX_PARENT AND\n               APPDEL1.APP_UID = APPDEL2.APP_UID AND APPDEL1.DEL_PREVIOUS = APPDEL2.DEL_INDEX\n        LIMIT 1\n    );\n\n    IF (@PREVIOUS_USR_UID IS NULL) THEN\n        SET @PREVIOUS_USR_UID = \'\';\n    END IF;\n\n    -- Update record in APP_CACHE_VIEW\n    UPDATE APP_CACHE_VIEW\n    SET    PREVIOUS_USR_UID = @PREVIOUS_USR_UID\n    WHERE  APP_UID = NEW.APP_UID AND DEL_INDEX = (SELECT APPDEL.DEL_INDEX\n                                                  FROM   APP_DELEGATION AS APPDEL\n                                                  WHERE  APPDEL.APP_UID = NEW.APP_UID AND APPDEL.DEL_PREVIOUS = 0\n                                                  LIMIT 1\n                                                 );\n\nEND'
sql_modes=0
definers='bn_processmaker@127.0.0.1'
client_cs_names='utf8'
connection_cl_names='utf8_general_ci'
db_cl_names='utf8_general_ci'
