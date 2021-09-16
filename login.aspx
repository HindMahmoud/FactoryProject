<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>

<!DOCTYPE html>
<html>
<head runat="server">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>Ecco-Sales | Log in</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../bootstrap/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="dist/css/1.css">
    <link rel="stylesheet" href="dist/css/2.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../../dist/css/AdminLTE.min.css">
  <!-- iCheck -->
  <link rel="stylesheet" href="../../plugins/iCheck/square/blue.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body class="hold-transition login-page">
    <form id="form1" runat="server">
<div class="login-box">
    <div class="login-box-body">
  <div class="login-logo">
     
      <span class="glyphicon glyphicon-user text-blue "></span> 
  </div>
  <!-- /.login-logo -->
   
    <p class="login-box-msg">برجاء تسجيل الدخول لمتابعة الحساب</p>

    
      <div class="form-group has-feedback">
        <asp:TextBox cssClass="form-control" placeholder="اسم المستخدم" ID="TextBox1" runat="server"></asp:TextBox>
        <%--<input type="email" class="form-control" placeholder="Email">--%>
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <asp:TextBox cssClass="form-control" placeholder="الرمز السرى" ID="TextBox2" runat="server" TextMode="Password"></asp:TextBox>
       <%-- <input type="password" class="form-control" placeholder="Password">--%>
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-xs-8">
         <%-- <div class="checkbox icheck">
            <label>
                <asp:CheckBox ID="CheckBox1" runat="server" /> Remember Me
             <%-- <input type="checkbox">--%> 
            <%--</label>--%>
          </div>
           <div class="col-xs-4">
       <asp:Button ID="Button1" CssClass="btn btn-primary btn-block btn-flat" runat="server" Text="دخول" OnClick="Button1_Click" />
          <%--<button type="submit" class="btn btn-primary btn-block btn-flat">Sign In</button>--%>
        </div>
        </div>
        <!-- /.col -->
       
        <!-- /.col -->
      </div>
 

   <%-- <div class="social-auth-links text-center">
      <p>- OR -</p>
      <a href="#" class="btn btn-block btn-social btn-facebook btn-flat"><i class="fa fa-facebook"></i> Sign in using
        Facebook</a>
      <a href="#" class="btn btn-block btn-social btn-google btn-flat"><i class="fa fa-google-plus"></i> Sign in using
        Google+</a>
    </div>--%>
    <!-- /.social-auth-links -->

 <%--   <a href="#">I forgot my password</a><br>--%>
   <%-- <a href="register.html" class="text-center">Register a new membership</a>--%>

  </div>
  <!-- /.login-box-body -->
</div>
<!-- /.login-box -->

<!-- jQuery 2.2.3 -->
<script src="../../plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<!-- iCheck -->
<script src="../../plugins/iCheck/icheck.min.js"></script>
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' // optional
    });
  });
</script>
        </form>
</body>
</html>
