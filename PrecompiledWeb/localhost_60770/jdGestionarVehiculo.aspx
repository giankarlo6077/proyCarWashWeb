<%@ page title="Gestión de Vehículos" language="VB" masterpagefile="~/MasterPage.master" autoeventwireup="false" inherits="jdGestionarVehiculo, App_Web_0fjqdpnu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 20px; border-radius: 8px; margin-bottom: 20px; font-size: 16pt; font-family: sans-serif; }
        .panel-grid { display: grid; grid-template-columns: 1fr 1.5fr; gap: 20px; }
        .panel-box { border: 1px solid #D1D5DB; padding: 20px; background: white; border-radius: 6px; }
        .campo-form { margin-bottom: 15px; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        
        /* Contenedor del scroll */
        .contenedor-tabla-scroll { max-height: 450px; overflow-y: auto; border: 1px solid #e0e0e0; }

        /* TABLA LIMPIA (IGUAL A TU IMAGEN) */
        .grid-estilo { width: 100%; border-collapse: collapse; font-family: 'Segoe UI', sans-serif; font-size: 14px; }
        .grid-estilo th { background-color: #1F2937; color: white; padding: 12px; text-align: left; position: sticky; top: 0; z-index: 1; font-weight: 600; }
        .grid-estilo td { padding: 12px; border-bottom: 1px solid #E5E7EB; color: #333; }
        
        /* Botones */
        .btn-base { border: none; padding: 10px 15px; color: white; font-weight: bold; border-radius: 4px; cursor: pointer; font-size: 9pt; }
        .btn-seleccionar { background-color: #1F2937; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-weight: bold; }
        .btn-buscar { background-color: #1F2937; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="titulo-modulo">GESTIÓN DE VEHÍCULOS</div>
    <div class="panel-grid">
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdVehiculo" runat="server" Value="0" />
            <div class="campo-form"><label>Placa:</label><asp:TextBox ID="txtPlaca" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="campo-form"><label>DNI Dueño:</label><asp:TextBox ID="txtDni" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="campo-form"><label>Año Fab.:</label><asp:TextBox ID="txtAño" runat="server" CssClass="form-control"></asp:TextBox></div>
            <div class="campo-form"><label>Modelo:</label><asp:DropDownList ID="cboModelo" runat="server" CssClass="form-control"></asp:DropDownList></div>
            
            <div style="display:flex; gap:10px;">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-base" BackColor="#6B7280" OnClick="btnNuevo_Click" />
                <asp:Button ID="btnModificar" runat="server" Text="MODIFICAR" CssClass="btn-base" BackColor="#2563EB" OnClick="btnModificar_Click" />
                <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-base" BackColor="#059669" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="CANCELAR" CssClass="btn-base" BackColor="#DC2626" OnClick="btnCancelar_Click" />
            </div>
            <asp:Label ID="lblMensaje" runat="server" style="display:block; margin-top:10px; font-weight:bold;"></asp:Label>
        </div>

        <div class="panel-box">
            <div style="display:flex; gap:10px; margin-bottom:10px;">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por placa..."></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" />
            </div>
            
            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvVehiculos" runat="server" AutoGenerateColumns="false" 
                    CssClass="grid-estilo" DataKeyNames="ID" 
                    GridLines="None" 
                    OnRowCommand="dgvVehiculos_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Placa" HeaderText="Placa" />
                        <asp:BoundField DataField="Modelo" HeaderText="Modelo" />
                        <asp:BoundField DataField="DNI" HeaderText="DNI" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSel" runat="server" Text="Seleccionar" CssClass="btn-seleccionar" CommandName="Seleccionar" CommandArgument='<%# Eval("ID") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>