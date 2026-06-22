<%@ page title="Gestión de Trabajador" language="VB" masterpagefile="~/MasterPage.master" autoeventwireup="false" inherits="jdGestionarTrabajador, App_Web_0fjqdpnu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo {
            background-color: #111827;
            color: white;
            text-align: center;
            padding: 25px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .titulo-modulo h1 {
            margin: 0;
            font-size: 20pt;
            letter-spacing: 0.5px;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            max-width: 650px;
            margin: 0 auto;
        }

        .seccion-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .campo-form {
            margin-bottom: 16px;
        }

        .campo-form.ancho-completo {
            grid-column: span 2;
        }

        .campo-form label {
            display: block;
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
            background-color: #FFFFFF;
            color: #1F2937;
            transition: border-color 0.2s ease;
        }

        .campo-form .form-control:focus {
            outline: none;
            border-color: #1F2937;
        }

        .campo-form .form-control:disabled {
            background-color: #F3F4F6;
            color: #6B7280;
        }

        .campo-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
            grid-column: span 2;
        }

        .campo-checkbox label {
            font-size: 9pt;
            color: #1F2937;
            font-weight: bold;
            margin: 0;
        }

        .botonera {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            border-top: 1px solid #E5E7EB;
            padding-top: 20px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 24px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
            transition: opacity 0.2s ease;
        }

        .btn-accion:hover {
            opacity: 0.9;
        }

        .btn-guardar {
            background-color: #059669;
        }

        .btn-cancelar {
            background-color: #DC2626;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 9pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <asp:Label ID="lblTitulo" runat="server" Text="REGISTRAR TRABAJADOR" AssociatedControlID="txtTrabajador"></asp:Label>
    </div>

    <div class="panel-box">
        <asp:HiddenField ID="hdnIdTrabajador" runat="server" Value="0" />

        <div class="seccion-form">
            
            <div class="campo-form ancho-completo">
                <label for="<%= txtTrabajador.ClientID %>">Nombre del Trabajador:</label>
                <asp:TextBox ID="txtTrabajador" runat="server" CssClass="form-control" placeholder="Nombre completo..."></asp:TextBox>
            </div>

            <div class="campo-form">
                <label for="<%= txtDni.ClientID %>">DNI (Documento de Identidad):</label>
                <asp:TextBox ID="txtDni" runat="server" CssClass="form-control" MaxLength="8" placeholder="8 dígitos..."></asp:TextBox>
            </div>

            <div class="campo-form">
                <label for="<%= txtTelefono.ClientID %>">Teléfono / Celular:</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9" placeholder="9 dígitos..."></asp:TextBox>
            </div>

            <div class="campo-form">
                <label for="<%= cboSexo.ClientID %>">Sexo:</label>
                <asp:DropDownList ID="cboSexo" runat="server" CssClass="form-control">
                    <asp:ListItem Value="" Text="-- Seleccione --"></asp:ListItem>
                    <asp:ListItem Value="M" Text="Masculino"></asp:ListItem>
                    <asp:ListItem Value="F" Text="Femenino"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="campo-form">
                <label for="<%= txtCorreo.ClientID %>">Correo Electrónico:</label>
                <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" placeholder="ejemplo@correo.com..."></asp:TextBox>
            </div>

            <div class="campo-form ancho-completo">
                <label for="<%= cboTipoTrabajador.ClientID %>">Tipo de Trabajador:</label>
                <asp:DropDownList ID="cboTipoTrabajador" runat="server" CssClass="form-control">
                </asp:DropDownList>
            </div>

            <div class="campo-form">
                <label for="<%= cboDepartamento.ClientID %>">Departamento:</label>
                <asp:DropDownList ID="cboDepartamento" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="cboDepartamento_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <div class="campo-form">
                <label for="<%= cboProvincia.ClientID %>">Provincia:</label>
                <asp:DropDownList ID="cboProvincia" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="cboProvincia_SelectedIndexChanged">
                </asp:DropDownList>
            </div>

            <div class="campo-form ancho-completo">
                <label for="<%= cboDistrito.ClientID %>">Distrito:</label>
                <asp:DropDownList ID="cboDistrito" runat="server" CssClass="form-control">
                </asp:DropDownList>
            </div>

            <div class="campo-checkbox">
                <asp:CheckBox ID="chkActivo" runat="server" Checked="true" />
                <label for="<%= chkActivo.ClientID %>">Activo / Vigente</label>
            </div>

        </div>

        <div class="botonera">
            <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" />
            <asp:Button ID="btnCancelar" runat="server" Text="CANCELAR" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
        </div>

        <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>

    </div>
</asp:Content>
