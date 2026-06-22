<%@ Page Title="Gestión de Descuentos" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarDescuento.aspx.vb" Inherits="jdGestionarDescuento" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo { 
            background-color: #1F2937; 
            color: white; 
            text-align: center; 
            padding: 20px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            font-size: 16pt; 
            font-family: Verdana, sans-serif; 
            font-weight: bold;
        }
        
        .panel-grid { display: grid; grid-template-columns: 1fr 1.8fr; gap: 20px; align-items: start; }
        .panel-box { border: 1px solid #D1D5DB; padding: 20px; background-color: #FFFFFF; border-radius: 6px; }
        .campo-form { margin-bottom: 15px; }
        .campo-form label { display: block; font-size: 9pt; font-weight: bold; color: #1F2937; margin-bottom: 5px; font-family: Verdana, sans-serif; }
        
        .form-control { 
            width: 100%; 
            padding: 8px 10px; 
            border: 1px solid #D1D5DB; 
            border-radius: 4px; 
            box-sizing: border-box; 
            font-family: Verdana, sans-serif;
            font-size: 9pt;
        }

        .form-control:disabled, .form-control[readonly] { background-color: #F3F4F6; color: #6B7280; }
        .campo-checkbox { display: flex; align-items: center; gap: 8px; margin-top: 5px; }
        .campo-checkbox label { font-size: 9pt; font-weight: normal; margin: 0; }

        .contenedor-tabla-scroll { max-height: 550px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; }
        .grid-estilo { width: 100%; border-collapse: collapse; font-family: Verdana, sans-serif; font-size: 9pt; }
        .grid-estilo th { background-color: #1F2937; color: white; padding: 12px; text-align: left; position: sticky; top: 0; z-index: 1; font-weight: normal; }
        .grid-estilo td { padding: 10px 12px; border-bottom: 1px solid #E5E7EB; color: #333; }
        .grid-estilo tr:hover { background-color: #F3F4F6; }
        
        .botonera { display: flex; gap: 8px; margin-top: 20px; flex-wrap: wrap; justify-content: center; }
        .btn-base { border: none; padding: 8px 12px; color: white; font-weight: bold; border-radius: 4px; cursor: pointer; font-size: 8.5pt; font-family: Verdana, sans-serif; }
        
        .btn-nuevo { background-color: #6B7280; }
        .btn-modificar { background-color: #2563EB; }
        .btn-guardar { background-color: #059669; }
        .btn-baja { background-color: #D97706; } 
        .btn-cancelar { background-color: #DC2626; }
        
        .btn-seleccionar { background-color: #1F2937; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-family: Verdana, sans-serif; }
        .btn-seleccionar:hover { background-color: #374151; }
        
        .fila-buscar { display: flex; gap: 10px; margin-bottom: 15px; }
        .btn-buscar { background-color: #1F2937; color: white; padding: 0 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 11pt; }
        
        .mensaje-notificacion { display:block; margin-top:15px; font-weight:bold; font-family: Verdana, sans-serif; font-size: 9pt; text-align: center; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="titulo-modulo">GESTIÓN DE DESCUENTOS</div>
    
    <div class="panel-grid">
        
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdDescuento" runat="server" Value="0" />
            
            <div class="campo-form">
                <label>ID:</label>
                <asp:TextBox ID="txtID" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>
            
            <div class="campo-form">
                <label>Código:</label>
                <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="campo-form">
                <label>Aplica a:</label>
                <asp:DropDownList ID="cboAplicaA" runat="server" CssClass="form-control">
                    <asp:ListItem Value="0">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="Producto">Producto</asp:ListItem>
                    <asp:ListItem Value="Servicio">Servicio</asp:ListItem>
                    <asp:ListItem Value="Ambos">Ambos</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="campo-form">
                <label>Descripción:</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Valor:</label>
                <asp:TextBox ID="txtValor" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Tipo descuento:</label>
                <asp:DropDownList ID="cboTipoDescuento" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>

            <div class="campo-form">
                <label>Fecha Inicio:</label>
                <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Fecha Fin:</label>
                <asp:TextBox ID="txtFechaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
            </div>

            <div class="campo-checkbox">
                <asp:CheckBox ID="chkActivo" runat="server" />
                <label>Activo</label>
            </div>
            
            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-base btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnModificar" runat="server" Text="MODIFICAR" CssClass="btn-base btn-modificar" OnClick="btnModificar_Click" CausesValidation="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-base btn-guardar" OnClick="btnGuardar_Click" CausesValidation="false" />
                <asp:Button ID="btnDarDeBaja" runat="server" Text="DAR BAJA" CssClass="btn-base btn-baja" OnClick="btnDarDeBaja_Click" CausesValidation="false" />
                <asp:Button ID="btnLimpiar" runat="server" Text="LIMPIAR" CssClass="btn-base btn-cancelar" OnClick="btnLimpiar_Click" CausesValidation="false" />
            </div>
            
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje-notificacion"></asp:Label>
        </div>

        <div class="panel-box">
            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por código de descuento..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
            </div>
            
            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvDescuentos" runat="server" AutoGenerateColumns="false" 
                    CssClass="grid-estilo" DataKeyNames="ID" 
                    GridLines="None" 
                    OnRowCommand="dgvDescuentos_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Codigo" HeaderText="Código" />
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                        <asp:BoundField DataField="Aplica a" HeaderText="Aplica a" />
                        <asp:BoundField DataField="Valor" HeaderText="Valor" />
                        <asp:BoundField DataField="Tipo de descuento" HeaderText="Tipo" />
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# IIf(Convert.ToBoolean(Eval("estado")), "Activo", "Inactivo") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSel" runat="server" Text="Seleccionar" CssClass="btn-seleccionar" CommandName="Seleccionar" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">No hay descuentos registrados.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>
        
    </div>
</asp:Content>