<!DOCTYPE html>
<%@page import="ru.ifmo.is.util.Util"%>
<html>
<head lang="en">
    <style>
        html, body {
            margin: 0;
            padding: 0;

            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
	<script src="<%=Util.getIcCube()%>/doc/ic3-report/app/reporting/js/loader/ic3bootstrap.js"></script>

    <script type="text/javascript">

        /**
         * Location of the icCube reporting files; not necessarily co-located
         * with this HTML page. For example, assuming this file is located within
         * the "Docs" repository of a local icCube install, this path would be :
         *
         *            /icCube/doc/ic3-report/app/reporting/
         */

        var ic3root = "<%=Util.getIcCube()%>/doc/ic3-report/app/";
        var ic3rootLocal = "<%=Util.getIcCube()%>/doc/ic3-report/app-local/";

        var options = {

            root: ic3root,
            rootLocal: ic3rootLocal,

            callback: function () {

                var options = {
                    dsSettings:{
                        userName:"",
                        userPassword:"",
                        url: "<%=Util.getIcCube()%>/gvi"
                    },

                    mode:ic3.MainReportMode.REPORTING,
                    menu:ic3.MainReportMenuMode.OFF,

                    noticesLevel:ic3.NoticeLevel.ERROR,

                    report: {
                        name: '<%=Util.getIcCubeMainReport()%>'
                    }
                };

                ic3.startReport(options);
            }
        };

        ic3ready(options);

    </script>
</body>
</html>