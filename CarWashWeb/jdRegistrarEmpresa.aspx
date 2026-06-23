<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdRegistrarEmpresa.aspx.vb" Inherits="jdRegistrarEmpresa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
      <style>
        .re-wrapper {
            font-family: Verdana, Geneva, sans-serif;
        }

        .re-header {
            background-color: #1F2937;
            color: #ffffff;
            border-radius: 8px;
            padding: 24px 32px;
            margin-bottom: 24px;
        }

        .re-header h1 {
            margin: 0;
            font-size: 24px;
        }

        .re-alert {
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

        .re-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 28px 32px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
        }

        .re-row {
            display: grid;
            gap: 18px 28px;
            margin-bottom: 20px;
        }

        .re-row-1 {
            grid-template-columns: 1fr;
        }

        .re-row-2 {
            grid-template-columns: 1fr 1fr;
        }

        .re-row-3 {
            grid-template-columns: 1fr 1fr 1fr;
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

        .re-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 12px;
        }

        .btn-dark {
            background-color: #1F2937;
            color: #ffffff;
            border: none;
            padding: 9px 26px;
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
            padding: 9px 26px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 13px;
            font-family: Verdana, Geneva, sans-serif;
            cursor: pointer;
        }

        .btn-outline:hover {
            background-color: #F3F4F6;
        }

        @media (max-width: 900px) {
            .re-row-2, .re-row-3 {
                grid-template-columns: 1fr;
            }
        }
    </style>

    <div class="re-wrapper">

        <div class="re-header">
            <h1>Registrar Nueva Empresa</h1>
        </div>

        <asp:Label ID="lblMensaje" runat="server" CssClass="re-alert" Visible="false" EnableViewState="false"></asp:Label>

        <div class="re-card">

            <div class="re-row re-row-1">
                <div class="gc-field">
                    <label>Raz&oacute;n Social</label>
                    <asp:TextBox ID="txtRazonSocial" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="re-row re-row-2">
                <div class="gc-field">
                    <label>RUC</label>
                    <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Tel&eacute;fono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9"></asp:TextBox>
                </div>
            </div>

            <div class="re-row re-row-1">
                <div class="gc-field">
                    <label>Correo</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                </div>
            </div>

            <div class="re-row re-row-1">
                <div class="gc-field">
                    <label>Direcci&oacute;n</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>

            <div class="re-row re-row-3">
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
            </div>

            <div class="re-footer">
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline" CausesValidation="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn-dark" />
            </div>

        </div>

    </div>

</asp:Content>

