<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarRol.aspx.vb" Inherits="jdGestionarRol" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <style>
        .gr-wrapper {
            font-family: Verdana, Geneva, sans-serif;
        }

        .gr-header {
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

        .gr-header h1 {
            margin: 0;
            font-size: 24px;
        }

        .gr-header p {
            margin: 4px 0 0;
            font-size: 13px;
            color: #D1D5DB;
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

        .gr-alert {
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

        .gr-card {
            background-color: #ffffff;
            border: 1px dashed #9CA3AF;
            border-radius: 8px;
            padding: 24px 28px;
            margin-bottom: 24px;
        }

        .gr-card-title {
            font-size: 14px;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 20px;
            letter-spacing: 0.5px;
        }

        .gr-row {
            display: grid;
            gap: 18px 24px;
            margin-bottom: 18px;
        }

        .gr-row-3 {
            grid-template-columns: 0.6fr 2fr 0.8fr;
        }

        .gr-row-1 {
            grid-template-columns: 1fr;
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

        .gc-field .form-control:disabled {
            background-color: #F3F4F6;
            color: #6B7280;
        }

        .gr-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
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

        .btn-dark:hover:enabled {
            background-color: #111827;
        }

        .btn-dark:disabled {
            background-color: #9CA3AF;
            cursor: not-allowed;
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

        .btn-outline:hover:enabled {
            background-color: #F3F4F6;
        }

        .btn-outline:disabled {
            color: #9CA3AF;
            border-color: #D1D5DB;
            cursor: not-allowed;
        }

        .gr-list-card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px 24px 8px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.06);
        }

        .gr-list-title {
            font-size: 14px;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 14px;
        }

        .gr-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        .gr-grid th {
            background-color: #1F2937;
            color: #ffffff;
            text-align: left;
            padding: 10px 12px;
        }

        .gr-grid td {
            padding: 9px 12px;
            border-bottom: 1px solid #E5E7EB;
        }

        .gr-grid tr:nth-child(even) td {
            background-color: #F9FAFB;
        }

        .gr-grid .btn-select {
            background-color: #1F2937;
            color: #ffffff;
            border: none;
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
        }

        @media (max-width: 900px) {
            .gr-row-3 {
                grid-template-columns: 1fr;
            }

            .gr-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>

    <div class="gr-wrapper">

        <div class="gr-header">
            <div>
                <h1>Gesti&oacute;n de Roles</h1>
                <p>Administra los roles del sistema</p>
            </div>
            <asp:Button ID="btnNuevoRol" runat="server" Text="Nuevo Rol" CssClass="btn-light" />
        </div>

        <asp:Label ID="lblMensaje" runat="server" CssClass="gr-alert" Visible="false" EnableViewState="false"></asp:Label>

        <div class="gr-card">
            <div class="gr-card-title">DATOS DEL ROL</div>

            <div class="gr-row gr-row-3">
                <div class="gc-field">
                    <label>Id Rol</label>
                    <asp:TextBox ID="txtIdRol" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Nombre del Rol</label>
                    <asp:TextBox ID="txtNombreRol" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
                <div class="gc-field">
                    <label>Estado</label>
                    <asp:DropDownList ID="cboEstado" runat="server" CssClass="form-control" Enabled="false">
                        <asp:ListItem Text="Seleccione..." Value="" />
                        <asp:ListItem Text="ACTIVO" Value="True" />
                        <asp:ListItem Text="INACTIVO" Value="False" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="gr-row gr-row-1">
                <div class="gc-field">
                    <label>Descripci&oacute;n</label>
                    <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
                </div>
            </div>

            <div class="gr-footer">
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-outline" CausesValidation="false" Enabled="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn-dark" Enabled="false" />
            </div>
        </div>

        <div class="gr-list-card">
            <div class="gr-list-title">Roles registrados</div>
            <asp:GridView ID="gvRoles" runat="server" AutoGenerateColumns="false" CssClass="gr-grid"
                GridLines="None" DataKeyNames="idrol" Width="100%">
                <Columns>
                    <asp:BoundField DataField="idrol" HeaderText="Id Rol" />
                    <asp:BoundField DataField="rol" HeaderText="Nombre del Rol" />
                    <asp:BoundField DataField="estado" HeaderText="Estado" />
                    <asp:BoundField DataField="descripcion" HeaderText="Descripci&oacute;n" />
                    <asp:CommandField ShowSelectButton="true" SelectText="Ver" ControlStyle-CssClass="btn-select" />
                </Columns>
            </asp:GridView>
        </div>

    </div>


</asp:Content>

