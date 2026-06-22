<%@ page language="VB" autoeventwireup="false" inherits="jdRecuperarContrasena, App_Web_a2x5mcfx" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Recuperar Contraseña - Car Wash</title>

    <style>
        body {
            font-family: Verdana, sans-serif;
            background-color: #F3F4F6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .recuperar-card {
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            box-sizing: border-box;
        }

        .recuperar-card h1 {
            font-size: 20pt;
            color: #111827;
            margin: 0 0 10px 0;
            letter-spacing: 0.5px;
        }

        .recuperar-card .descripcion {
            font-size: 9pt;
            color: #374151;
            margin-bottom: 15px;
        }

        .separador {
            height: 4px;
            background-color: #111827;
            border: none;
            margin: 15px 0 25px 0;
        }

        .fila-form {
            display: flex;
            align-items: center;
            margin-bottom: 18px;
            gap: 15px;
        }

        .fila-form label {
            min-width: 150px;
            font-weight: bold;
            font-size: 9pt;
            color: #1F2937;
        }

        .fila-form .form-control {
            flex: 1;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }

        .fila-form .form-control:focus {
            outline: none;
            border-color: #1F2937;
        }

        .fila-form .form-control:disabled {
            background-color: #F3F4F6;
            color: #9CA3AF;
        }

        .pregunta-texto {
            font-size: 9pt;
            color: #1F2937;
            font-style: italic;
        }

        .captcha-box {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .captcha-codigo {
            background-color: #E5E7EB;
            padding: 8px 18px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 11pt;
            letter-spacing: 2px;
            color: #1F2937;
            user-select: none;
        }

        .btn-refrescar {
            background-color: #F3F4F6;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            cursor: pointer;
            font-size: 10pt;
            padding: 7px 12px;
            font-family: Verdana, sans-serif;
        }

        .btn-refrescar:hover {
            background-color: #E5E7EB;
        }

        .btn-confirmar, .btn-guardar {
            display: block;
            margin: 20px auto 5px auto;
            background-color: #1F2937;
            color: white;
            border: none;
            padding: 12px 40px;
            border-radius: 4px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 10pt;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .btn-confirmar:hover, .btn-guardar:hover {
            background-color: #374151;
        }

        .btn-confirmar:disabled, .btn-guardar:disabled {
            background-color: #9CA3AF;
            cursor: not-allowed;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 9pt;
            display: block;
            text-align: center;
            margin-top: 10px;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9pt;
            display: block;
            text-align: center;
            margin-top: 10px;
        }

        .volver-login {
            display: block;
            text-align: center;
            margin-top: 20px;
            font-size: 8pt;
            color: #6B7280;
            text-decoration: none;
        }

        .volver-login:hover {
            color: #1F2937;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">

        <div class="recuperar-card">

            <h1>RECUPERAR CONTRASEÑA</h1>
            <p class="descripcion">
                Ingresa tu usuario, responde la pregunta de seguridad y escribe el código captcha,
                luego haz clic en confirmar.
            </p>

            <hr class="separador" />

            <!-- ===== PASO 1: USUARIO ===== -->
            <div class="fila-form">
                <label>Usuario:</label>
                <asp:TextBox ID="txtUsuario" runat="server" CssClass="form-control" placeholder="Ingresa tu usuario"></asp:TextBox>
                <asp:Button ID="btnBuscarPregunta" runat="server" Text="Buscar" CssClass="btn-refrescar" OnClick="btnBuscarPregunta_Click" />
            </div>

            <!-- ===== PASO 2: PREGUNTA / RESPUESTA / CAPTCHA ===== -->
            <div class="fila-form">
                <label>Pregunta:</label>
                <asp:Label ID="lblPregunta" runat="server" CssClass="pregunta-texto" Text="—"></asp:Label>
            </div>

            <div class="fila-form">
                <label>Respuesta:</label>
                <asp:TextBox ID="txtRespuesta" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>

            <div class="fila-form">
                <label>Captcha:</label>
                <div class="captcha-box">
                    <asp:Label ID="lblCaptcha" runat="server" CssClass="captcha-codigo" Text="------"></asp:Label>
                    <asp:LinkButton ID="btnRefrescarCaptcha" runat="server" CssClass="btn-refrescar" OnClick="btnRefrescarCaptcha_Click">🔄</asp:LinkButton>
                </div>
            </div>

            <div class="fila-form">
                <label>Código captcha:</label>
                <asp:TextBox ID="txtCaptchaIngresado" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>

            <asp:Button ID="btnConfirmar" runat="server" Text="CONFIRMAR" CssClass="btn-confirmar" Enabled="false" OnClick="btnConfirmar_Click" />

            <hr class="separador" />

            <!-- ===== PASO 3: NUEVA CONTRASEÑA ===== -->
            <div class="fila-form">
                <label>Nueva Contraseña:</label>
                <asp:TextBox ID="txtNuevaContrasena" runat="server" CssClass="form-control" TextMode="Password" MaxLength="15" Enabled="false"></asp:TextBox>
            </div>

            <div class="fila-form">
                <label>Confirmar Contraseña:</label>
                <asp:TextBox ID="txtConfirmarContrasena" runat="server" CssClass="form-control" TextMode="Password" MaxLength="15" Enabled="false"></asp:TextBox>
            </div>

            <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-guardar" Enabled="false" OnClick="btnGuardar_Click" />

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>

            <a href="jdInicioSesion.aspx" class="volver-login">← Volver a Iniciar Sesión</a>

        </div>

    </form>
</body>
</html>