<!DOCTYPE html>
<html>
    <head>
        <title>ZNC Sign Up</title>
        <script src="http://code.jquery.com/jquery-latest.min.js"></script>
        <script src="http://cdn.sockjs.org/sockjs-0.3.min.js"></script>

        <script>
            $(function() {

                console.log('server started');

                function connect() {
                    Sock = new SockJS('http://127.0.0.1:4001');

                    Sock.onopen = function() {
                        console.log('opened sock');
                    };

                    Sock.onmessage = function(e) {
                        if (!(e.data.charAt(0) === '{')) {
                            if (e.data.charAt(0) === 'S') {
                                alert(e.data);
                            }
                            else {
                                $("#status").text(e.data);
                            }
                        }
                    };

                    Sock.onclose = function() {
                        console.log('disconnected.');
                        Sock = null;
                    };

                }   //connect

                function disconnect() {
                    console.log('disconnecting....');
                    Sock.close();
                }

                connect();

                $( "form" ).submit(function(event) {

                    var username = $( "#username" ).val();
                    var password = $( "#pwd1" ).val();
                    var verify_password = $( "#pwd2").val();

                    if (password === verify_password) {
                        var info = "{ \"username\" : \"" + username + "\" , "
                            + " \"password\" : \"" + password + "\" }";

                        Sock.send(info);
                        $( "#status").text("");
                    }

                    else {
                        $( "#status").text("Passwords do not match");
                    }

                    event.preventDefault();

                }); //form submission


            }); //on page load

        </script>
</head>
<body>
    <form>
        <div id="status" style="color:red"></div><br>

        <div>Username: <input type="text" name="username" id="username"></div>
        <div>Password:* <input type="password" name="pwd1" id="pwd1"></div>
        <div>Verify Password: <input type="password" name="pwd2"  id="pwd2"></div>

        <div><input type="submit" name="submit" value="Submit" id="submit"></div>
    </form>

    <p style="color:grey">* passwords may not be entirely secure</p>
</body>
</html>