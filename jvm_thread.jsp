<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JVM THREADS</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.css" />
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.3.1/semantic.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.4.1/semantic.min.js"></script>
    <script>
        function toggle(stackid) {
            stackid = "#" + stackid;
            console.log(stackid);
            if ($(stackid)[0].className.includes('hide')) {
                $(stackid).removeClass('hide')
            } else {
                $(stackid).addClass('hide')
            }
        }
        function setModalThreadId(threadId) {
            $('#iThreadId').val(threadId)
           $('.ui.modal').modal('show');
        }
        $(document).on("click","#thredkillformsubmit",function() {
            $(this).parents("form").submit();
        });

    </script>
    <style>
        .hide {
        display: none;
    }

    .labels tr td {
        font-weight: bold;
    }

    .label tr td label {
        display: block;
    }

    .scroll-btn {
            position: fixed;
            right: 20px;
            padding: 10px 20px;
            background-color: gray;
            background-repeat: no-repeat;
            border: none;
            cursor: pointer;
            overflow: hidden;
            outline: none;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            box-shadow: 2px 2px 10px rgba(0, 0, 0, 0.2);
        }

        .top-btn {
            bottom: 20px;
        }

        .bottom-btn {
            bottom: 20px;
        }
    </style>
</head>

<body>
    <div>
        <h2>Memory Details</h2>
        <%
            Runtime mem_object = Runtime.getRuntime();
           
            String memory = "<table class='ui blue celled table'><thead class='ui celled table'><tr> <th colspan='1'> Total Memory (in MB) </th> <th colspan='1'> Used Memory (in MB)</th> <th colspan='1'> Free Memory (in MB)</th> </tr> </thead><tbody><tr> <td colspan='1'>" + String.valueOf(mem_object.totalMemory() / 1048576) + " </td> <td colspan='1'>" +
                    String.valueOf((mem_object.totalMemory() - mem_object.freeMemory()) / 1048576) + "</td> <td colspan='1'>" +
                    String.valueOf(mem_object.freeMemory() / 1048576)+"</td> </tr></tbody></table>";
            out.println(memory+"<br><br><br>");
            String iThreadId = request.getParameter("iThreadId");
            if (iThreadId != null) {
                for (Thread t : Thread.getAllStackTraces().keySet()) {
                    if ((t.getId() + "").equalsIgnoreCase(iThreadId)) {
                        t.interrupt();

                        out.println(iThreadId +"  "+ t.getName() +" is interrupted.\n");
                    }
                }
            }

        %>
        <div>
            <h2>Thread Details</h2>
            <div>
                <button type="button" onclick="Array.from(document.getElementsByClassName('stacktrace')).forEach(e=>{e.className = 'stacktrace'})" class="ui button">Show All Stacktrace</button><button type="button" onclick="Array.from(document.getElementsByClassName('stacktrace')).forEach(e=>{e.className = 'stacktrace hide'})" class="ui button">Hide All Stacktrace</button>
                <table class="ui blue celled table">
                    <thead class="ui celled table">
                        <tr>
                            <th colspan="1">S No</th>
                            <th colspan="1">Thread ID</th>
                            <th colspan="1">Thread Name</th>
                            <th colspan="1">State</th>
                            <th colspan="1">Priority</th>
                            <th colspan="1">Daemon</th>
                            <th colspan="1">Is Alive</th>
                            <th colspan="1">Is Interrupted</th>
                            <th colspan="1">Thread Group Name</th>
                            <th colspan="1">Stack trace</th>
                            <th colspan="1">Interrupt</th>
                        </tr>
                    </thead>
                    <% 
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                try {
                    int counter = 0;
                for (Thread t : Thread.getAllStackTraces().keySet()) {try{%>
                    <tbody class="">
                        <tr>
                            <td colspan="1">
                                <%= ++counter %>
                            </td>
                            <td colspan="1">
                                <%= t.getId() %>
                            </td>
                            <td colspan="1">
                                <%= t.getName() %>
                            </td>
                            <td colspan="1">
                                <%= t.getState() %>
                            </td>
                            <td colspan="1">
                                <%= t.getPriority() %>
                            </td>
                            <td colspan="1">
                                <%= t.isDaemon() %>
                            </td>
                            <td colspan="1">
                                <%= t.isAlive() %>
                            </td>
                            <td colspan="1">
                                <%= t.isInterrupted() %>
                            </td>
                            <td colspan="1">
                                <%= t.getThreadGroup().getName() %>
                            </td>
                            <td onclick="toggle('stack<%= t.getId() %>')" colspan="1"> <button type="button" class="ui button">show/hide stacktrace</button></td>
                            <td onclick="setModalThreadId('<%= t.getId() %>')" colspan="1"> <button type="button" class="negative ui button">Interrupt</button></td>
                        </tr>
                        <tr class="stacktrace" id="stack<%= t.getId() %>">
                            <td colspan="8">
                                <% 
                                StringBuilder result = new StringBuilder();
                                StackTraceElement[] stackTraceElements = t.getStackTrace();
                                for (int i = 0; i < stackTraceElements.length; i++) {
                                    result.append(stackTraceElements[i].toString());
                                    if (i < stackTraceElements.length - 1) {
                                        result.append("\n<br>");
                                    }
                                }
                                out.println(result.toString());
                            %>
                            </td>
                        </tr>
                    </tbody>
                    <%}catch(Exception ee){}}}catch(Exception e){e.printStackTrace();}%>
                </table>
            </div>
            <h2>System Properties</h2>
            <%
            String html = "<table class='ui blue celled table'><tbody>";
            for(String prop : System.getProperties().stringPropertyNames()) {
                
                html += "<tr><td colspan='1'><strong>"+prop+"</strong></td><td colspan='1'><strong>"+prop.replace("."," ")+"</strong></td> <td colspan='1'>"+ System.getProperty(prop) + "</td></tr>";
            }
            html +=" </tbody></table>";
            out.println(html+"<br><br><br>");
        %>
            <div>
                <div class="ui basic modal centered aligned">
                    <form action="./jt.jsp" method="POST">
                        <div class="content">
                            <p>Are you sure to Interrupt the thread?</p>
                        </div>
                        <br>
                        <div class="actions">
                            <div class="ui red basic cancel inverted button">
                                <i class="remove icon"></i>
                                No
                            </div>
                            <input type="hidden" name="iThreadId" id="iThreadId" value="" />
                            <div id="thredkillformsubmit" class="ui red ok inverted button">
                                <i class="checkmark icon"></i>
                                Yes
                            </div>
                            </input>
                        </div>
                    </form>
                </div>
            </div>
            <button class="scroll-btn top-btn hide" id="scrollTopButton" onclick="scrollToTop()"><i class="arrow alternate circle up icon"></i></button>
            <button class="scroll-btn bottom-btn" id="scrollDownButton" onclick="scrollToBottom()"><i class="arrow alternate circle down icon"></i></button>
</body>
<script>
window.onscroll = function() { scrollFunction() };

function scrollFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        $("#scrollTopButton").removeClass('hide');
        $("#scrollDownButton").addClass('hide');
    } else {
        $("#scrollTopButton").addClass('hide');
        $("#scrollDownButton").removeClass('hide');
    }
}

function scrollToTop() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function scrollToBottom() {
    window.scrollTo({ top: document.body.scrollHeight, behavior: 'smooth' });
}
</script>

</html>