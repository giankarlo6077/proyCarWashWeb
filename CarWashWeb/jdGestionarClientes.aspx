<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarClientes.aspx.vb" Inherits="jdGestionarClientes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <style>
        .gc-wrapper {
            font-family: Verdana, Geneva, sans-serif;
        }

        .gc-header {
            background-color: #1F2937;
            color: #ffffff;
            border-radius: 8px;
            padding: 24px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            margin-bottom: 24px;
        }

        .gc-header h1 {
            margin: 0;
            font-size: 24px;
        }

        .gc-header p {
            margin: 4px 0 0;
            font-size: 13px;
            color: #D1D5DB;
        }

        .gc-header-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn-light {
            background-color: #ffffff;
            color: #1F2937;
            border: none;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 13px;
            font-family: Verdana, Geneva, sans-serif;
            cursor: pointer;
        }

        .btn-light:hover {
            background-color: #E5E7EB;
        }

        .gc-alert {
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

        .gc-card {
            background-color: #ffffff;
            border: 1px dashed #9CA3AF;
            border-radius: 8px;
            padding: 24px 28px;
            margin-bottom: 24px;
        }

        .gc-card-title {
            font-size: 14px;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .gc-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0 36px;
        }

        .gc-col {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }

        .gc-spacer {
            flex: 1 1 auto;
        }

        .gc-inline {
            display: flex;
            gap: 12px;
            align-items: flex-end;
        }

        .gc-inline > .gc-field {
            flex: 1 1 auto;
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

        .gc-field .form-control[readonly] {
            background-color: #F3F4F6;
        }

        .btn-dark {
            background-color: #1F2937;
            color: #ffffff;
            border: none;
            padding: 9px 18px;
            border-radius: 4px;
            font-weight: bold;
            font-size: 13px;
            font-family: Verdana, Geneva, sans-serif;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-dark:hover {
            background-color: #111827;
        }

        .btn-block {
            width: 100%;
            padding: 12px;
        }

        .gc-footer {
            display: flex;
            justify-content: flex-end;
        }

        @media (max-width: 768px) {
            .gc-grid {
                grid-template-columns: 1fr;
                gap: 24px 0;
            }

            .gc-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>

    <div class="gc-wrapper">

        <div class="gc-header">
            <div>
                <h1>Gestión de Clientes</h1>
                <p>Administra los clientes registrados</p>
            </div>
            <div class="gc-header-actions">
                <asp:Button ID="btnNuevaPersona" runat="server" Text="Nueva Persona" CssClass="btn-light" />
                <asp:Button ID="btnNuevaEmpresa" runat="server" Text="Nueva Empresa" CssClass="btn-light" />
            </div>
        </div>

        <asp:Label ID="lblMensaje" runat="server" CssClass="gc-alert" Visible="false" EnableViewState="false"></asp:Label>

        <div class="gc-card">
            <div class="gc-card-title">BUSCAR CLIENTE</div>

            <div class="gc-grid">

                <!-- Columna Persona -->
                <div class="gc-col">
                    <div class="gc-inline">
                        <div class="gc-field" style="flex: 0 0 140px;">
                            <label>Tipo de documento</label>
                            <asp:DropDownList ID="cboTipoDoc" runat="server" CssClass="form-control"></asp:DropDownList>
                        </div>
                        <div class="gc-field">
                            <label>N&deg; Documento</label>
                            <asp:TextBox ID="txtDoc" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnBuscarPer" runat="server" Text="Buscar" CssClass="btn-dark" />
                    </div>

                    <div class="gc-field">
                        <label>Nombres y Apellidos</label>
                        <asp:TextBox ID="txtNombreAp" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="gc-inline">
                        <div class="gc-field">
                            <label>Correo</label>
                            <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                        <div class="gc-field">
                            <label>Tel&eacute;fono</label>
                            <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                        </div>
                    </div>

                    <div class="gc-spacer"></div>

                    <asp:Button ID="btnModificarPersona" runat="server" Text="Modificar Persona" CssClass="btn-dark btn-block" />
                </div>

                <!-- Columna Empresa -->
                <div class="gc-col">
                    <div class="gc-inline">
                        <div class="gc-field">
                            <label>RUC</label>
                            <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnBuscarEm" runat="server" Text="Buscar" CssClass="btn-dark" />
                    </div>

                    <div class="gc-field">
                        <label>Raz&oacute;n Social</label>
                        <asp:TextBox ID="txtRazonSocial" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                    </div>

                    <div class="gc-spacer"></div>

                    <asp:Button ID="btnModificarEmpresa" runat="server" Text="Modificar Empresa" CssClass="btn-dark btn-block" />
                </div>

            </div>
        </div>

        <div class="gc-footer">
            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-dark" />
        </div>
    </div>
</asp:Content>

