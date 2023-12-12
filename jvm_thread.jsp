<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
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

    #scrollButton {
      display: none;
      position: fixed;
      bottom: 20px;
      right: 10px;
      z-index: 99;
      font-size: 18px;
      border: none;
      outline: none;
      background-color: gray;
      color: white;
      cursor: pointer;
      padding: 15px;
      border-radius: 4px;
    }

    #scrollButton:hover {
      background-color: #555;
    }
    </style>
</head>

<body>
    <div>
        <%
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
            
            <div>
                <button type="button" onclick="Array.from(document.getElementsByClassName('stacktrace')).forEach(e=>{e.className = 'stacktrace'})" class="ui button">Show All Stacktrace</button><button type="button" onclick="Array.from(document.getElementsByClassName('stacktrace')).forEach(e=>{e.className = 'stacktrace hide'})" class="ui button">Hide All Stacktrace</button>
                <table class="ui celled table">
                    <thead class="ui celled table">
                        <tr>
                            <th colspan="1">Thread ID</th>
                            <th colspan="1">Name</th>
                            <th colspan="1">State</th>
                            <th colspan="1">Priority</th>
                            <th colspan="1">Daemon</th>
                            <th colspan="1">Is Interrupted</th>
                            <th colspan="1">Stacktrace</th>
                            <th colspan="1">Interrupt</th>
                        </tr>
                    </thead>
                    <% 
                response.setContentType("text/html");
                response.setCharacterEncoding("UTF-8");
                try {
                for (Thread t : Thread.getAllStackTraces().keySet()) {try{%>
                    <tbody class="">
                        <tr>
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
                                <%= t.isInterrupted() %>
                            </td>
                            <td onclick="toggle('stack<%= t.getId() %>')" colspan="1"> <button type="button" class="ui button">show/hide stacktrace</button></td>
                            <td onclick="setModalThreadId('<%= t.getId() %>')" colspan="1"> <button type="button" class="negative ui button">Interrupt</button></td>
                        </tr>
                        <tr class="stacktrace hide" id="stack<%= t.getId() %>">
                            <td colspan="8">
                                <%= java.util.Arrays.stream(t.getStackTrace()).skip(0).map(StackTraceElement::toString).reduce((s1,
                                s2) -> s1
                                + "\n<br>" + s2).get() %>
                            </td>
                        </tr>
                    </tbody>
                    <%}catch(Exception ee){}}}catch(Exception e){e.printStackTrace();}%>
                </table>
            </div>
            <div>
                <div class="ui basic modal">
                    <form action="/lmt/jvm_thread.jsp" method="POST">
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
                            <div id="thredkillformsubmit" class="ui green ok inverted button">
                                <i class="checkmark icon"></i>
                                Yes
                            </div>
                            </input>
                        </div>
                    </form>
                </div>
            </div>
            <button onclick="topFunction()" id="scrollButton" title="Go to top"><i class="arrow alternate circle up icon"></i></button>

</body>

<script>
// Get the button
let mybutton = document.getElementById("scrollButton");

// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {scrollFunction()};

function scrollFunction() {
  if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
}

// When the user clicks on the button, scroll to the top of the document
function topFunction() {
  document.body.scrollTo({
        top: 0,
        behavior: "smooth"
    });
  document.documentElement.scrollTop = 0;
}
</script>

</html>