<%@ Page Language="VB" AutoEventWireup="false" CodeFile="jdInicioSesion.aspx.vb" Inherits="jdInicioSesion" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Iniciar Sesión - Car Wash</title>

    <style>
        body {
            font-family: Verdana, sans-serif;
            background-color: #F3F4F6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 350px;
            text-align: center;
        }

        .login-header h2 {
            color: #1F2937;
            font-size: 18pt;
            margin-bottom: 5px;
        }

        .login-header p {
            color: #6B7280;
            font-size: 9pt;
            margin-bottom: 25px;
        }

        .form-group {
            text-align: left;
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            box-sizing: border-box;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
        }

        .form-control:focus {
            outline: none;
            border-color: #1F2937;
        }

        .btn-ingresar {
            background-color: #1F2937;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 4px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 10pt;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.3s;
        }

        .btn-ingresar:hover {
            background-color: #374151;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 8pt;
            margin-top: 15px;
            display: block;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            
            <div class="login-header">
                <h2>🚗 Car Wash</h2>
                <p>Ingresa tus credenciales para continuar</p>
            </div>

            <div class="form-group">
                <label for="txtUsuario">Usuario</label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" placeholder="Ej: admin"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtPassword">Contraseña</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
            </div>

            <asp:Button ID="btnIngresar" runat="server" Text="INGRESAR" CssClass="btn-ingresar" />

            <asp:Label ID="lblError" runat="server" CssClass="mensaje-error" Text=""></asp:Label>

        </div>
    </form>
</body>
</html>