<%@ Page Title="Gestión de Servicios" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarServicio.aspx.vb" Inherits="jdGestionarServicio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 25px 20px; border-radius: 8px; margin-bottom: 25px; }
        .titulo-modulo h1 { margin: 0; font-size: 20pt; letter-spacing: 0.5px; }
        .panel-grid { display: grid; grid-template-columns: 1fr 1.3fr; gap: 30px; align-items: start; }
        .panel-box { border: 1px dashed #D1D5DB; border-radius: 6px; padding: 20px; background-color: #FFFFFF; }
        .contenedor-tabla-scroll { max-height: 420px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; margin-top: 10px; }
        .campo-form { margin-bottom: 16px; }
        .campo-form label { display: block; font-size: 9pt; font-weight: bold; color: #1F2937; margin-bottom: 5px; }
        .campo-form .form-control { width: 100%; padding: 8px 10px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .campo-form .form-control:disabled { background-color: #F3F4F6; color: #6B7280; }
        .fila-buscar { display: flex; gap: 10px; margin-bottom: 15px; }
        .fila-buscar .form-control { flex: 1; }
        .btn-buscar { background-color: #1F2937; color: white; border: none; border-radius: 4px; padding: 0 16px; cursor: pointer; font-size: 11pt; }
        .btn-buscar:hover { background-color: #374151; }
        .botonera { display: flex; gap: 10px; justify-content: flex-end; margin-top: 25px; }
        .btn-accion { border: none; border-radius: 4px; padding: 10px 20px; font-weight: bold; font-family: Verdana, sans-serif; font-size: 9pt; cursor: pointer; color: white; }
        .btn-nuevo { background-color: #6B7280; }
        .btn-nuevo:hover { background-color: #4B5563; }
        .btn-modificar { background-color: #2563EB; }
        .btn-modificar:hover { background-color: #1D4ED8; }
        .btn-guardar { background-color: #059669; }
        .btn-guardar:hover { background-color: #047857; }
        .btn-cancelar { background-color: #DC2626; }
        .btn-cancelar:hover { background-color: #B91C1C; }
        .grid-servicios { width: 100%; border-collapse: collapse; font-size: 9pt; }
        .grid-servicios th { background-color: #1F2937; color: white; padding: 10px; text-align: left; position: sticky; top: 0; z-index: 1; }
        .grid-servicios td { padding: 8px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid-servicios tr:hover { background-color: #F3F4F6; }
        .btn-seleccionar { background-color: #1F2937; color: white; border: none; border-radius: 4px; padding: 5px 12px; font-size: 8pt; cursor: pointer; }
        .btn-seleccionar:hover { background-color: #374151; }
        .mensaje-error { color: #DC2626; font-size: 9pt; display: block; margin-top: 15px; text-align: center; font-weight:bold; }
        .mensaje-exito { color: #059669; font-size: 9pt; display: block; margin-top: 15px; text-align: center; font-weight:bold; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="titulo-modulo">
        <h1>GESTIÓN DE SERVICIOS (CAR WASH)</h1>
    </div>

    <div class="panel-grid">
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdServicio" runat="server" Value="0" />

            <div class="campo-form">
                <label>Código:</label>
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#F3F4F6"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Tipo de Vehículo:</label>
                <asp:DropDownList ID="cboTipoVehiculo" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="cboTipoVehiculo_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <div class="campo-form">
                <label>Nombre del Servicio:</label>
                <asp:DropDownList ID="cboNombre" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="cboNombre_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <div class="campo-form">
                <label>Precio Calculado (S/.):</label>
                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#F3F4F6"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Duración Estimada (minutos):</label>
                <asp:TextBox ID="txtDuracion" runat="server" CssClass="form-control" ReadOnly="true" BackColor="#F3F4F6"></asp:TextBox>
            </div>

            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-accion btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-accion btn-guardar" OnClick="btnGuardar_Click" CausesValidation="false" />
                <asp:Button ID="btnCancelar" runat="server" Text="CANCELAR" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

        <div class="panel-box">
            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por código..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvServicios" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-servicios" GridLines="None" Width="100%"
                    DataKeyNames="idServicio" OnRowCommand="dgvServicios_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="idServicio" HeaderText="Código" />
                        <asp:BoundField DataField="servicio" HeaderText="Nombre" />
                        <asp:BoundField DataField="precioactual" HeaderText="Precio" />
                        <asp:BoundField DataField="duracion" HeaderText="Tiempo" />
                        <asp:BoundField DataField="tipovehiculo" HeaderText="Vehículo" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" CssClass="btn-seleccionar"
                                    CommandName="Seleccionar" CommandArgument='<%# Eval("idServicio") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">No se encontraron servicios registrados.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>