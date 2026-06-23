<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdRegistrarPersona.aspx.vb" Inherits="jdRegistrarPersona" Debug="true" ValidateRequest="false" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <style>
        .rp-wrapper {
            font-family: Verdana, Geneva, sans-serif;
        }

        .rp-header {
            background-color: #1F2937;
            color: #ffffff;
            border-radius: 8px;
            padding: 24px 32px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 24px;
        }

        .rp-header h1 {
            margin: 0;
            font-size: 24px;
        }

        .rp-header-meta {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
        }

        .rp-header-meta .gc-field label {
            color: #D1D5DB;
        }

        .rp-header-meta .form-control {
            width: 150px;
        }

        .rp-alert {
            padding: 10px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            font-size: 13px;
            font-weight: bold;
            display: block;
        }

        .alert-success {
            background-color: #D1FAE5;
            color: #065F46;
            border: 1px solid #10B981;
        }

        .alert-warning {
            background-color: #FEF3C7;
            color: #92400E;
            border: 1px solid #F59E0B;
        }

        .alert-danger {
            background-color: #FEE2E2;
            color: #991B1B;
            border: 1px solid #EF4444;
        }

        .rp-card {
            background-color: #ffffff;
            border: 1px dashed #9CA3AF;
            border-radius: 8px;
            padding: 24px 28px;
            margin-bottom: 24px;
        }

        .rp-card-title {
            font-size: 14px;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .rp-row {
            display: grid;
            gap: 18px 24px;
            margin-bottom: 18px;
        }

        .rp-row-2 {
            grid-template-columns: 2fr 1fr;
        }

        .rp-row-3 {
            grid-template-columns: 2fr 1fr 1fr;
        }

        .rp-row-4 {
            grid-template-columns: 1fr 1fr 1fr 1fr;
        }

        .gc-field label {
            display: block;
            font-weight: bold;
            font-size: 13px;
            margin-bottom: 6px;
            color: #111827;
        }

        .gc-field .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #9CA3AF;
            border-radius: 4px;
            font-family: Verdana, Geneva, sans-serif;
            font-size: 13px;
            box-sizing: border-box;
            background-color: #ffffff;
        }

        .gc-field .form-control[readonly],
        .gc-field .form-control:disabled {
            background-color: #F3F4F6;
            color: #4B5563;
        }

        .rp-sexo-group {
            display: flex;
            align-items: center;
            gap: 28px;
            margin-top: 4px;
        }

        .rp-sexo-group label {
            font-weight: normal;
            font-size: 13px;
            margin-left: 6px;
            color: #111827;
        }

        .rp-sexo-title {
            font-weight: bold;
            font-size: 13px;
            color: #111827;
            margin-bottom: 8px;
        }

        .rp-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-bottom: 24px;
        }

        .btn-dark {
            background-color: #1F2937;
            color: #ffffff;
            border: none;
            padding: 9px 22px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 13px;
            font-family: Verdana, Geneva, sans-serif;
            cursor: pointer;
        }

        .btn-dark:hover {
            background-color: #111827;
        }

        .btn-outline {
            background-color: #ffffff;
            color: #1F2937;
            border: 1px solid #1F2937;
            padding: 9px 22px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 13px;
            font-family: Verdana, Geneva, sans-serif;
            cursor: pointer;
        }

        .btn-outline:hover {
            background-color: #F3F4F6;
        }

        .rp-list-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px 24px 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
        }

        .rp-list-title {
            font-size: 14px;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 14px;
        }

        .rp-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .rp-grid th {
            background-color: #1F2937;
            color: #ffffff;
            text-align: left;
            padding: 10px 12px;
        }

        .rp-grid td {
            padding: 9px 12px;
            border-bottom: 1px solid #E5E7EB;
        }

        .rp-grid tr:nth-child(even) td {
            background-color: #F9FAFB;
        }

        .rp-grid .btn-select {
            background-color: #1F2937;
            color: #ffffff;
            border: none;
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
        }

        @media (max-width: 900px) {
            .rp-row-2, .rp-row-3, .rp-row-4 {
                grid-template-columns: 1fr;
            }

            .rp-header {
                flex-direction: column;
            }
        }
    </style>

    <div class="rp-wrapper">

        <div class="rp-header">
            <h1>Registrar Nuevo Cliente</h1>
            <div class="rp-header-meta">
                <div class="gc-field">
                    <label>Fecha</label>
                    <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Id Cliente</label>
                    <asp:TextBox ID="txtId" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>
        </div>

        <asp:Label ID="lblMensaje" runat="server" CssClass="rp-alert" Visible="false" EnableViewState="false"></asp:Label>

        <div class="rp-card">
            <div class="rp-card-title">DATOS PERSONALES</div>

            <div class="rp-row rp-row-2">
                <div class="gc-field">
                    <label>Nombres y Apellidos</label>
                    <asp:TextBox ID="txtNombreAp" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>N&deg; DNI</label>
                    <asp:TextBox ID="txtDNI" runat="server" CssClass="form-control" MaxLength="8"></asp:TextBox>
                </div>
            </div>

            <div class="rp-row rp-row-3">
                <div class="gc-field">
                    <label>Direcci&oacute;n</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Correo</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Tel&eacute;fono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9"></asp:TextBox>
                </div>
            </div>

            <div class="rp-row rp-row-4">
                <div class="gc-field">
                    <label>Departamento</label>
                    <asp:DropDownList ID="cboDepartamento" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                </div>
                <div class="gc-field">
                    <label>Provincia</label>
                    <asp:DropDownList ID="cboProvincia" runat="server" CssClass="form-control" AutoPostBack="true"></asp:DropDownList>
                </div>
                <div class="gc-field">
                    <label>Distrito</label>
                    <asp:DropDownList ID="cboDistrito" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="gc-field">
                    <label>Fecha de Nacimiento</label>
                    <asp:TextBox ID="txtFechaNac" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
            </div>

            <div class="gc-field">
                <div class="rp-sexo-title">Sexo</div>
                <div class="rp-sexo-group">
                    <span>
                        <asp:RadioButton ID="rbMasculino" runat="server" GroupName="sexo" />
                        <label for="rbMasculino">Masculino</label>
                    </span>
                    <span>
                        <asp:RadioButton ID="rbFemenino" runat="server" GroupName="sexo" />
                        <label for="rbFemenino">Femenino</label>
                    </span>
                </div>
            </div>
        </div>

        <div class="rp-footer">
            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline" CausesValidation="false" />
            <asp:Button ID="btnNuevo" runat="server" Text="Nuevo" CssClass="btn-dark" />
        </div>

        <div class="rp-list-card">
            <div class="rp-list-title">Personas registradas</div>
            <asp:GridView ID="gvPersonas" runat="server" AutoGenerateColumns="false" CssClass="rp-grid"
                GridLines="None" DataKeyNames="idcliente" Width="100%">
                <Columns>
                    <asp:BoundField DataField="idcliente" HeaderText="ID Cliente" />
                    <asp:BoundField DataField="persona" HeaderText="Nombres y Apellidos" />
                    <asp:BoundField DataField="sexo" HeaderText="Sexo" />
                    <asp:BoundField DataField="direccion" HeaderText="Direcci&oacute;n" />
                    <asp:BoundField DataField="correo" HeaderText="Correo" />
                    <asp:BoundField DataField="telefono" HeaderText="Tel&eacute;fono" />
                    <asp:CommandField ShowSelectButton="true" SelectText="Ver" ControlStyle-CssClass="btn-select" />
                </Columns>
            </asp:GridView>
        </div>

    </div>
</asp:Content>

