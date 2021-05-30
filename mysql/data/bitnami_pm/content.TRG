TYPE=TRIGGERS
triggers='CREATE DEFINER=`bn_processmaker`@`127.0.0.1` TRIGGER CONTENT_UPDATE BEFORE UPDATE ON CONTENT\n\nFOR EACH ROW\nBEGIN\n\n  DECLARE str TEXT;\n  \n  IF (NEW.CON_VALUE IS NULL) THEN\n    SET str = \'\';\n  ELSE\n    SET str = NEW.CON_VALUE;\n  END IF;\n  \n  CASE (NEW.CON_CATEGORY)\n    WHEN \'APP_TITLE\' THEN\n      BEGIN\n        UPDATE APP_CACHE_VIEW\n        SET    APP_TITLE = str\n        WHERE  APP_UID = NEW.CON_ID;\n      END;\n    \n    WHEN \'PRO_TITLE\' THEN\n      BEGIN\n        UPDATE APP_CACHE_VIEW\n        SET    APP_PRO_TITLE = str\n        WHERE  PRO_UID = NEW.CON_ID;\n      END;\n      \n    WHEN \'TAS_TITLE\' THEN\n      BEGIN\n        UPDATE APP_CACHE_VIEW\n        SET    APP_TAS_TITLE = str\n        WHERE  TAS_UID = NEW.CON_ID;\n      END;\n    \n    ELSE\n      BEGIN\n      END;\n  END CASE;\n  \nEND'
sql_modes=0
definers='bn_processmaker@127.0.0.1'
client_cs_names='utf8'
connection_cl_names='utf8_general_ci'
db_cl_names='utf8_general_ci'
