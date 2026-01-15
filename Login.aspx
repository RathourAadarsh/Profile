<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>User Login</title>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body {
            margin: 0;
            font-family: 'Poppins', sans-serif;
            height: 100vh;
            background: linear-gradient(135deg, #ffe6ea 0%, #ffffff 60%);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-wrapper {
            width: 380px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            padding: 35px;
            text-align: center;
        }

        .logo {
            font-size: 28px;
            font-weight: 600;
            color: #e31422;
            margin-bottom: 5px;
        }

        h3 {
            font-weight: 500;
            margin-bottom: 20px;
        }

        .tabs {
            display: flex;
            margin-bottom: 20px;
        }

            .tabs button {
                flex: 1;
                padding: 10px;
                border: none;
                cursor: pointer;
                background: #f2f2f2;
                font-weight: 500;
            }

                .tabs button.active {
                    background: #e25563;
                    color: #fff;
                }

        .input-box {
            position: relative;
            margin-bottom: 15px;
        }

            .input-box i {
                position: absolute;
                top: 50%;
                left: 12px;
                transform: translateY(-50%);
                color: #999;
            }

            .input-box input {
                width: 85%;
                padding: 12px 12px 12px 40px;
                border-radius: 6px;
                border: 1px solid #ddd;
                font-size: 14px;
                background: #f6f6f6;
            }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: #e25563;
            border: none;
            border-radius: 6px;
            color: #fff;
            font-size: 15px;
            cursor: pointer;
       }
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

    <script>
        function showLogin() {
            document.getElementById("loginDiv").style.display = "block";
            document.getElementById("registerDiv").style.display = "none";
            document.getElementById("btnLoginTab").classList.add("active");
            document.getElementById("btnRegTab").classList.remove("active");
        }

        function showRegister() {
            document.getElementById("loginDiv").style.display = "none";
            document.getElementById("registerDiv").style.display = "block";
            document.getElementById("btnRegTab").classList.add("active");
            document.getElementById("btnLoginTab").classList.remove("active");
        }
    </script>
</head>

<body>
    <form runat="server">
        <div class="login-wrapper">
            <div class="logo">
                <h4 style="text-align: center;">Sign in/ Register</h4>
            </div>
            <div class="tabs">
                <button type="button" id="btnLoginTab" onclick="showLogin()">Sign In</button>
                <button type="button" id="btnRegTab" class="active" onclick="showRegister()">Register</button>
            </div>

            <!-- LOGIN -->
            <div id="loginDiv" style="display: none">
                <div class="input-box">
                    <i class="fa fa-envelope"></i>
                    <asp:TextBox ID="txtEmail" runat="server" placeholder="Email"></asp:TextBox>
                </div>

                <div class="input-box">
                    <i class="fa fa-key"></i>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-login" OnClick="btnLogin_Click" />
            </div>
            <!-- REGISTER -->
            <div id="registerDiv" >
                <div class="input-box">
                    <i class="a-user"></i>
                    <asp:TextBox ID="txtName" runat="server" placeholder="Please Enter Your Name"></asp:TextBox>
                </div>
                <div class="input-box">
                    <i class="fa fvelope"></i>
                    <asp:TextBox ID="txtRegEmail" TextMode="Email" runat="server" placeholder="Please Enter Your Email ID/Username"></asp:TextBox>
                </div>

                <div class="input-box">
                    <i class="f-phone"></i>
                    <asp:TextBox ID="txtMobile" MaxLength="10" minlength="10" runat="server" placeholder="Please Enter Your Mobile No."></asp:TextBox>
                </div>
                <div class="input-box">
                    <i class="a-lock"></i>
                    <asp:TextBox ID="txtRegPassword" runat="server" MaxLength="16" MinLength="8"  TextMode="Password" placeholder="Please Enter Your Password"></asp:TextBox>
                </div>
                <div class="input-box">
                    <i class="fa flendar"></i>
                    <asp:TextBox ID="txtDob" runat="server" TextMode="date"></asp:TextBox>
                </div>
                <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn-login" OnClick="btnRegister_Click" />
            </div>
        </div>
    </form>
</body>
</html>
