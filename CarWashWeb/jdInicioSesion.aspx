<%@ Page Language="VB" AutoEventWireup="false" CodeFile="jdInicioSesion.aspx.vb" Inherits="jdInicioSesion" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Iniciar Sesión - Car Wash</title>

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            font-family: Verdana, sans-serif;
            margin: 0;
            padding: 0;
            height: 100%;
        }

        .login-fondo {
            position: relative;
            width: 100%;
            min-height: 100vh;
            background-image: url('Imagenes/Fondo2.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-wrapper {
            display: flex;
            width: 100%;
            max-width: 1000px;
            min-height: 460px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.35);
        }

        /* ===== PANEL IZQUIERDO: OSCURO SEMITRANSPARENTE SOBRE LA FOTO ===== */
        .login-info {
            flex: 1.1;
            background-color: rgba(17, 24, 39, 0.78);
            color: white;
            padding: 50px 55px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-info .etiqueta-superior {
            font-size: 8pt;
            letter-spacing: 1.5px;
            color: #9CA3AF;
            text-transform: uppercase;
            margin-bottom: 18px;
        }

        .login-info h1 {
            font-size: 26pt;
            font-weight: normal;
            line-height: 1.25;
            margin: 0 0 18px 0;
        }

        .login-info p {
            font-size: 9.5pt;
            color: #D1D5DB;
            line-height: 1.7;
            margin: 0;
            max-width: 380px;
        }

        /* ===== PANEL DERECHO: FORMULARIO SOBRE FONDO BLANCO SÓLIDO ===== */
        .login-form-panel {
            flex: 0.9;
            background-color: white;
            padding: 55px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-form-panel h2 {
            color: #111827;
            font-size: 17pt;
            font-weight: normal;
            margin: 0 0 30px 0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 8.5pt;
            color: #374151;
            margin-bottom: 7px;
        }

        .form-control {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #D1D5DB;
            border-radius: 3px;
            box-sizing: border-box;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            background-color: #FAFAFA;
        }

        .form-control:focus {
            outline: none;
            border-color: #111827;
            background-color: white;
        }

        .btn-ingresar {
            background-color: #1F2937;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            border-radius: 3px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            letter-spacing: 0.5px;
            cursor: pointer;
            margin-top: 10px;
            transition: background-color 0.25s;
        }

        .btn-ingresar:hover {
            background-color: #111827;
        }

        .enlace-recuperar {
            margin-top: 16px;
        }

        .enlace-recuperar a {
            font-size: 8.5pt;
            color: #6B7280;
            text-decoration: underline;
        }

        .enlace-recuperar a:hover {
            color: #111827;
        }

        .mensaje-error {
            color: #B91C1C;
            font-size: 8.5pt;
            margin-top: 18px;
            display: block;
        }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 800px) {
            .login-wrapper {
                flex-direction: column;
                max-width: 420px;
                min-height: auto;
            }

            .login-info, .login-form-panel {
                flex: 1;
                padding: 40px 35px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="login-fondo">
            <div class="login-wrapper">

                <!-- ===== PANEL IZQUIERDO: TEXTO SOBRE LA FOTO ===== -->
                <div class="login-info">
                    <div class="etiqueta-superior">Sistema de Gestión</div>
                    <h1>Gestiona tu negocio<br />de Car Wash</h1>
                    <p>Administra citas, clientes, vehículos, servicios y ventas desde una sola plataforma.</p>
                </div>

                <!-- ===== PANEL DERECHO: FORMULARIO ===== -->
                <div class="login-form-panel">

                    <h2>Iniciar sesión</h2>

                    <div class="form-group">
                        <label for="txtUsuario">Usuario</label>
                        <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" placeholder="Ej: admin"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtPassword">Contraseña</label>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnIngresar" runat="server" Text="INICIAR SESIÓN" CssClass="btn-ingresar" />

                    <div class="enlace-recuperar">
                        <a href="jdRecuperarContrasena.aspx">¿Has olvidado la contraseña?</a>
                    </div>

                    <asp:Label ID="lblError" runat="server" CssClass="mensaje-error" Text=""></asp:Label>

                </div>

            </div>
        </div>

    </form>
</body>
</html>