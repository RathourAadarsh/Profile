<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <style>
        .swal-footer {
            text-align: center !important;
        }

        .swal-text {
            font-size: 22px !important;
            text-align: center;
        }

        .swal-button {
            background-color: #184f34 !important;
        }
    </style>
    <script type="text/javascript" src="sweetalertnew.js"></script>
    <script type="text/javascript">
        function savealert(message, type) {
            swal({
                text: message,
                icon: type === 'success' ? 'success' : type === 'info' ? 'info' : type === 'error' ? 'error' : 'warning',
            });
        }
    </script>
    <script type="text/javascript">
        window.history.forward();
        function noBack() {
            window.history.forward();
        }
    </script>
    <title>Login Panel</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="icon" type="image/png" href="images/icons/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="vendor/animate/animate.css" />
    <link rel="stylesheet" type="text/css" href="vendor/css-hamburgers/hamburgers.min.css" />
    <link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css" />
    <link rel="stylesheet" type="text/css" href="css/util.css" />
    <link rel="stylesheet" type="text/css" href="css/main.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="limiter">
            <div class="container-login100">
                <div class="wrap-login100">
                    <div class="login100-form validate-form">
                        <span class="login100-form-title">Login Panel
                        </span>
                        <h6 runat="server" id="loginsms" style="color:darkgreen;font-weight:600;"></h6>
                        <div class="wrap-input100 validate-input" data-validate="Valid email is required: ex@abc.xyz">
                            <asp:TextBox ID="txtuserid" runat="server" CssClass="input100" placeholder="Username"></asp:TextBox>
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-envelope" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="wrap-input100 validate-input" data-validate="Password is required">
                            <asp:TextBox ID="txtpassword" runat="server" CssClass="input100"
                                TextMode="Password" placeholder="Password"></asp:TextBox>
                            <span class="focus-input100"></span>
                            <span class="symbol-input100">
                                <i class="fa fa-lock" aria-hidden="true"></i>
                            </span>
                        </div>
                        <div class="wrap-input100 validate-input" data-validate="Password is required">
                            <asp:DropDownList ID="ddlfinyear" runat="server" CssClass="input100"
                                placeholder="Password">
                            </asp:DropDownList>
                            <span class="focus-input100"></span>
                        </div>
                        <div class="container-login100-form-btn">
                            <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="login100-form-btn" OnClick="btnLogin_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
