<%@ Page Title="Detalle Orden de Trabajo" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdDetalleOrdenTrabajo.aspx.vb" Inherits="jdDetalleOrdenTrabajo" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<style>
    .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 20px; border-radius: 8px; margin-bottom: 20px; font-size: 16pt; font-family: sans-serif; }
    .panel-box { border: 1px solid #D1D5DB; padding: 20px; background: white; border-radius: 6px; margin-bottom: 16px; }
    .panel-box h3 { margin-top: 0; border-left: 4px solid #1F2937; padding-left: 10px; font-family: 'Segoe UI', sans-serif; }
    .campo-form { margin-bottom: 14px; }
    .campo-form label { display: block; font-weight: bold; margin-bottom: 4px; font-family: 'Segoe UI', sans-serif; font-size: 13px; }
    .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 13px; font-family: 'Segoe UI', sans-serif; }
    .form-control-readonly { width: 100%; padding: 8px; border: 1px solid #e5e7eb; border-radius: 4px; box-sizing: border-box; background: #F9FAFB; font-size: 13px; color: #374151; font-family: 'Segoe UI', sans-serif; }
    .fila-dos { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .fila-tres { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; }
    .fila-cuatro { display: grid; grid-template-columns: 1fr 1fr 1fr 1fr; gap: 16px; }

    /* Grids internos */
    .contenedor-tabla-scroll { max-height: 220px; overflow-y: auto; border: 1px solid #e0e0e0; border-radius: 4px; margin-bottom: 10px; }
    .grid-estilo { width: 100%; border-collapse: collapse; font-family: 'Segoe UI', sans-serif; font-size: 13px; }
    .grid-estilo th { background-color: #1F2937; color: white; padding: 10px 12px; text-align: left; position: sticky; top: 0; z-index: 1; font-weight: 600; }
    .grid-estilo td { padding: 10px 12px; border-bottom: 1px solid #E5E7EB; color: #333; }
    .grid-estilo tr:hover td { background-color: #F3F4F6; }

    /* Botones */
    .btn-base { border: none; padding: 10px 18px; color: white; font-weight: bold; border-radius: 4px; cursor: pointer; font-size: 9pt; font-family: 'Segoe UI', sans-serif; }
    .btn-agregar { background-color: #059669; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 9pt; }
    .btn-eliminar { background-color: #DC2626; color: white; border: none; padding: 4px 10px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-weight: bold; }
    .btn-volver { background-color: #374151; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 9pt; margin-bottom: 16px; }

    /* Modal */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.55); z-index: 1000; }
    .modal-box { background: white; margin: 4% auto; width: 680px; max-width: 95%; padding: 24px; border-radius: 8px; box-shadow: 0 8px 32px rgba(0,0,0,0.2); }
    .modal-box h3 { margin-top: 0; border-left: 4px solid #1F2937; padding-left: 10px; }
    .modal-tabla-scroll { max-height: 320px; overflow-y: auto; border: 1px solid #e0e0e0; border-radius: 4px; margin-bottom: 14px; }
    .btn-seleccionar-modal { background-color: #1F2937; color: white; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-weight: bold; }
    .btn-cerrar-modal { background-color: #6B7280; color: white; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; font-weight: bold; }

    .barra-acciones { display: flex; gap: 10px; margin-top: 10px; }
    .alerta { padding: 10px 14px; border-radius: 4px; margin-top: 10px; font-weight: bold; font-size: 13px; display: none; }
    .alerta-ok  { background: #D1FAE5; color: #065F46; border: 1px solid #6EE7B7; }
    .alerta-err { background: #FEE2E2; color: #991B1B; border: 1px solid #FCA5A5; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- Botón volver -->
    <asp:Button ID="btnVolver" runat="server" Text="← Volver" CssClass="btn-volver" OnClick="btnVolver_Click" />

    <!-- Título -->
    <div class="titulo-modulo">
        DETALLE ORDEN DE TRABAJO &nbsp;|&nbsp; CITA N°:
        <asp:Label ID="lblidCita" runat="server" style="font-size:18pt;" />
    </div>

    <!-- DATOS DE LA CITA -->
    <div class="panel-box">
        <h3>Datos de la Cita</h3>
        <div class="fila-cuatro">
            <div class="campo-form">
                <label>Fecha:</label>
                <asp:Label ID="lblFecha" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
            <div class="campo-form">
                <label>Hora:</label>
                <asp:Label ID="lblHora" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
            <div class="campo-form">
                <label>Estado:</label>
                <asp:DropDownList ID="cmbEstado" runat="server" CssClass="form-control">
                    <asp:ListItem Text="Pendiente"   Value="Pendiente"   />
                    <asp:ListItem Text="En Proceso"  Value="En Proceso"  />
                    <asp:ListItem Text="Realizado"   Value="Realizado"   />
                    <asp:ListItem Text="Cancelada"   Value="Cancelada"   />
                </asp:DropDownList>
            </div>
            <div class="campo-form">
                <label>Fecha de Recojo:</label>
                <asp:TextBox ID="dtpFechaRecojo" runat="server" CssClass="form-control" TextMode="Date" />
            </div>
        </div>
        <div class="fila-dos">
            <div class="campo-form">
                <label>Técnico Responsable:</label>
                <asp:DropDownList ID="cmbTrabajador" runat="server" CssClass="form-control" />
            </div>
            <div class="campo-form">
                <label>Comentario:</label>
                <asp:TextBox ID="txtComentario" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
            </div>
        </div>
    </div>

    <!-- DATOS DEL VEHÍCULO -->
    <div class="panel-box">
        <h3>Vehículo del Cliente</h3>
        <div class="fila-cuatro">
            <div class="campo-form">
                <label>Placa:</label>
                <asp:Label ID="lblPlaca" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
            <div class="campo-form">
                <label>Modelo:</label>
                <asp:Label ID="lblModelo" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
            <div class="campo-form">
                <label>Año Fab.:</label>
                <asp:Label ID="lblAno" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
            <div class="campo-form">
                <label>Teléfono:</label>
                <asp:Label ID="lblTelefono" runat="server" CssClass="form-control-readonly" style="display:block;" />
            </div>
        </div>
        <div class="campo-form">
            <label>Cliente:</label>
            <asp:Label ID="lblCliente" runat="server" CssClass="form-control-readonly" style="display:block;" />
        </div>
    </div>

    <!-- SERVICIOS -->
    <div class="panel-box">
        <h3>Servicios Realizados</h3>
        <div class="contenedor-tabla-scroll">
            <asp:GridView ID="dgvServicios" runat="server"
                AutoGenerateColumns="false" CssClass="grid-estilo"
                DataKeyNames="idServicio" GridLines="None"
                OnRowCommand="dgvServicios_RowCommand"
                EmptyDataText="No hay servicios agregados.">
                <Columns>
                    <asp:BoundField DataField="idServicio" HeaderText="ID" />
                    <asp:BoundField DataField="servicio"   HeaderText="Servicio" />
                    <asp:TemplateField HeaderText="Quitar">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="✕" CssClass="btn-eliminar"
                                CommandName="QuitarServicio"
                                CommandArgument='<%# Container.DataItemIndex %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:Button ID="btnAgregarServicio" runat="server" Text="+ Agregar Servicio"
            CssClass="btn-agregar" OnClick="btnAgregarServicio_Click" />
    </div>

    <!-- PRODUCTOS -->
    <div class="panel-box">
        <h3>Productos Usados</h3>
        <div class="contenedor-tabla-scroll">
            <asp:GridView ID="dgvProductos" runat="server"
                AutoGenerateColumns="false" CssClass="grid-estilo"
                DataKeyNames="idProducto" GridLines="None"
                OnRowCommand="dgvProductos_RowCommand"
                EmptyDataText="No hay productos agregados.">
                <Columns>
                    <asp:BoundField DataField="idProducto" HeaderText="ID" />
                    <asp:BoundField DataField="producto"   HeaderText="Producto" />
                    <asp:BoundField DataField="precio"     HeaderText="Precio" DataFormatString="{0:N2}" />
                    <asp:TemplateField HeaderText="Quitar">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="✕" CssClass="btn-eliminar"
                                CommandName="QuitarProducto"
                                CommandArgument='<%# Container.DataItemIndex %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:Button ID="btnAgregarProducto" runat="server" Text="+ Agregar Producto"
            CssClass="btn-agregar" OnClick="btnAgregarProducto_Click" />
    </div>

    <!-- MENSAJE Y BOTONES FINALES -->
    <asp:Label ID="lblMensaje" runat="server" style="display:block; font-weight:bold; margin-bottom:10px;" />
    <div class="barra-acciones">
        <asp:Button ID="btnGuardar"   runat="server" Text="GUARDAR"   CssClass="btn-base" BackColor="#059669" OnClick="btnGuardar_Click" />
        <asp:Button ID="btnCancelar"  runat="server" Text="CANCELAR"  CssClass="btn-base" BackColor="#DC2626" OnClick="btnCancelar_Click" />
    </div>

    <!-- ====== MODAL SERVICIOS ====== -->
    <div id="modalServicios" class="modal-overlay">
        <div class="modal-box">
            <h3>Seleccionar Servicio</h3>
            <p style="color:#6B7280; font-size:13px;">Haz clic en "Seleccionar" para agregar el servicio a la cita.</p>
            <div class="modal-tabla-scroll">
                <asp:GridView ID="dgvSelecServicios" runat="server"
                    AutoGenerateColumns="false" CssClass="grid-estilo"
                    DataKeyNames="idServicio" GridLines="None"
                    OnRowCommand="dgvSelecServicios_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="idServicio" HeaderText="ID" />
                        <asp:BoundField DataField="servicio"   HeaderText="Servicio" />
                        <asp:BoundField DataField="duracion"   HeaderText="Duración (min)" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button runat="server" Text="Seleccionar"
                                    CssClass="btn-seleccionar-modal"
                                    CommandName="ElegirServicio"
                                    CommandArgument='<%# Eval("idServicio") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Button ID="btnCerrarModalServicio" runat="server" Text="Cerrar"
                CssClass="btn-cerrar-modal" OnClick="btnCerrarModalServicio_Click" />
        </div>
    </div>

    <!-- ====== MODAL PRODUCTOS ====== -->
    <div id="modalProductos" class="modal-overlay">
        <div class="modal-box">
            <h3>Seleccionar Producto</h3>
            <p style="color:#6B7280; font-size:13px;">Haz clic en "Seleccionar" para agregar el producto a la cita.</p>
            <div class="modal-tabla-scroll">
                <asp:GridView ID="dgvSelecProductos" runat="server"
                    AutoGenerateColumns="false" CssClass="grid-estilo"
                    DataKeyNames="idProducto" GridLines="None"
                    OnRowCommand="dgvSelecProductos_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="idProducto"    HeaderText="ID" />
                        <asp:BoundField DataField="producto"      HeaderText="Producto" />
                        <asp:BoundField DataField="precio"        HeaderText="Precio" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="stock"         HeaderText="Stock" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button runat="server" Text="Seleccionar"
                                    CssClass="btn-seleccionar-modal"
                                    CommandName="ElegirProducto"
                                    CommandArgument='<%# Eval("idProducto") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Button ID="btnCerrarModalProducto" runat="server" Text="Cerrar"
                CssClass="btn-cerrar-modal" OnClick="btnCerrarModalProducto_Click" />
        </div>
    </div>

    <!-- Script para mostrar/ocultar modales -->
    <asp:HiddenField ID="hdnMostrarModalServicio" runat="server" Value="0" />
    <asp:HiddenField ID="hdnMostrarModalProducto" runat="server" Value="0" />
    <asp:HiddenField ID="hdnIdCita" runat="server" Value="0" />

    <script>
        window.onload = function () {
            if (document.getElementById('<%= hdnMostrarModalServicio.ClientID %>').value === '1') {
                document.getElementById('modalServicios').style.display = 'block';
            }
            if (document.getElementById('<%= hdnMostrarModalProducto.ClientID %>').value === '1') {
                document.getElementById('modalProductos').style.display = 'block';
            }
        };
    </script>

</asp:Content>

