<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="JdVentas.aspx.vb" Inherits="JdVentas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo {
            background-color: #111827;
            color: white;
            text-align: center;
            padding: 22px 20px;
            border-radius: 8px;
            margin-bottom: 22px;
        }

        .titulo-modulo h1 { margin: 0; font-size: 19pt; }

        .form-control {
            padding: 9px 12px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }

        .form-control:disabled, .form-control[readonly] {
            background-color: #F3F4F6;
            color: #6B7280;
        }

        /* ===== CABECERA ===== */
        .cabecera-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 22px;
        }

        .campo { display: flex; flex-direction: column; }
        .campo.full { grid-column: 1 / -1; }
        .campo label {
            font-size: 8.5pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
            text-transform: uppercase;
        }
        .campo .form-control { width: 100%; }

        /* ===== PANELES ===== */
        .panel-box {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 18px;
            margin-bottom: 22px;
            background: #FFFFFF;
        }

        .panel-box h3 {
            margin: 0 0 14px 0;
            font-size: 12pt;
            color: #1F2937;
            border-left: 4px solid #1F2937;
            padding-left: 10px;
        }

        .fila-buscar { display: flex; gap: 10px; margin-bottom: 12px; }
        .fila-buscar .form-control { flex: 1; }

        .cliente-sel {
            font-size: 9pt;
            color: #059669;
            font-weight: bold;
            margin-top: 8px;
        }

        /* ===== BOTONES ===== */
        .btn {
            border: none;
            border-radius: 4px;
            padding: 10px 18px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
        }

        .btn-azul { background-color: #1F2937; }
        .btn-azul:hover { background-color: #374151; }
        .btn-verde { background-color: #059669; }
        .btn-verde:hover { background-color: #047857; }
        .btn-rojo { background-color: #DC2626; }
        .btn-rojo:hover { background-color: #B91C1C; }
        .btn-gris { background-color: #6B7280; }
        .btn-gris:hover { background-color: #4B5563; }

        .btn-mini {
            border: none; border-radius: 4px; padding: 6px 12px;
            font-size: 8pt; font-weight: bold; cursor: pointer; color: white;
        }

        .acciones-detalle {
            display: flex; justify-content: space-between; align-items: center;
            margin-top: 16px; flex-wrap: wrap; gap: 12px;
        }

        .total-box {
            display: flex; align-items: center; gap: 10px;
            font-size: 13pt; font-weight: bold; color: #111827;
        }
        .total-box .form-control {
            width: 150px; font-size: 13pt; font-weight: bold; text-align: right;
        }

        /* ===== GRILLAS ===== */
        .grid {
            width: 100%; border-collapse: collapse; font-size: 9pt;
        }
        .grid th {
            background-color: #1F2937; color: white; padding: 9px 10px;
            text-align: left; position: sticky; top: 0; z-index: 1;
        }
        .grid td { padding: 7px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid tr:hover { background-color: #F3F4F6; }
        .scroll-200 { max-height: 200px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; }
        .scroll-260 { max-height: 260px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; }

        /* ===== MODALES ===== */
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(17,24,39,0.6);
            display: flex; align-items: center; justify-content: center; z-index: 1000;
        }
        .modal-box {
            background: white; border-radius: 10px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3); overflow: hidden;
            max-height: 92vh; display: flex; flex-direction: column;
        }
        .modal-box.ancho { width: 820px; max-width: 94%; }
        .modal-box.comprobante { width: 720px; max-width: 94%; }
        .modal-header {
            background-color: #1F2937; color: white; padding: 14px 20px;
            font-size: 12.5pt; font-weight: bold;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-body { padding: 20px; overflow-y: auto; }

        /* ===== MENSAJES ===== */
        .mensaje-error { color:#DC2626; background:#FEF2F2; border:1px solid #FECACA;
            font-size:9pt; display:block; padding:10px 14px; border-radius:4px; margin-bottom:14px; }
        .mensaje-exito { color:#059669; background:#ECFDF5; border:1px solid #A7F3D0;
            font-size:9pt; display:block; padding:10px 14px; border-radius:4px; margin-bottom:14px; }

        /* ===== COMPROBANTE (área imprimible) ===== */
        .comp-doc { border: 1px solid #D1D5DB; border-radius: 6px; padding: 18px; }
        .comp-titulo {
            background: #1F2937; color: white; text-align: center;
            padding: 8px; border-radius: 4px; font-weight: bold; margin-bottom: 14px;
        }
        .comp-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 12px; }
        .comp-totales {
            margin-top: 14px; display: flex; flex-direction: column; gap: 6px;
            align-items: flex-end;
        }
        .comp-totales .linea { display: flex; gap: 10px; align-items: center; font-size: 9.5pt; }
        .comp-totales .linea .form-control { width: 130px; text-align: right; }
        .comp-son { font-size: 9pt; font-style: italic; color: #374151; margin-top: 10px; }

        /* ===== IMPRESIÓN: sólo el comprobante ===== */
        @media print {
            body * { visibility: hidden !important; }
            #areaImpresion, #areaImpresion * { visibility: visible !important; }
            #areaImpresion {
                position: absolute; left: 0; top: 0; width: 100%;
                box-shadow: none; border: none;
            }
            .no-print { display: none !important; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div style="margin-bottom:14px;">
        <asp:Button ID="btnVolver" runat="server" Text="← Volver" CssClass="btn btn-azul"
            OnClick="btnVolver_Click" CausesValidation="false" />
    </div>

    <div class="titulo-modulo">
        <h1>GESTIÓN DE VENTAS</h1>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

    <%-- ===== CABECERA ===== --%>
    <div class="cabecera-grid">
        <div class="campo">
            <label>N° de Venta</label>
            <asp:TextBox ID="txtNumeroVenta" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
        </div>
        <div class="campo">
            <label>Tipo de Comprobante</label>
            <asp:DropDownList ID="cboTipoComprobante" runat="server" CssClass="form-control"
                AutoPostBack="true" OnSelectedIndexChanged="cboTipoComprobante_SelectedIndexChanged">
                <asp:ListItem>Boleta</asp:ListItem>
                <asp:ListItem>Factura</asp:ListItem>
            </asp:DropDownList>
        </div>
        <div class="campo">
            <label>Fecha</label>
            <asp:TextBox ID="txtFecha" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
        </div>
        <div class="campo">
            <label>Hora</label>
            <asp:TextBox ID="txtHora" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
        </div>
    </div>

    <%-- ===== CLIENTE ===== --%>
    <div class="panel-box">
        <h3>Cliente</h3>
        <div class="fila-buscar">
            <asp:TextBox ID="txtCliente" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar cliente por nombre / razón social..."></asp:TextBox>
        </div>
        <div class="scroll-200">
            <asp:GridView ID="dgvCliente" runat="server" AutoGenerateColumns="false"
                CssClass="grid" GridLines="None" Width="100%"
                OnRowCommand="dgvCliente_RowCommand">
                <Columns>
                    <asp:BoundField DataField="tipo" HeaderText="Tipo" />
                    <asp:BoundField DataField="cliente" HeaderText="Nombre / Razón Social" />
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:Button ID="btnSelCliente" runat="server" Text="Seleccionar"
                                CssClass="btn-mini btn-azul" CommandName="SelCliente"
                                CommandArgument='<%# Eval("cliente") %>' CausesValidation="false" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding:18px;text-align:center;color:#6B7280;">No se encontraron clientes.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <asp:HiddenField ID="hdnClienteNombre" runat="server" Value="" />
        <asp:Label ID="lblClienteSel" runat="server" CssClass="cliente-sel" Text="Ningún cliente seleccionado."></asp:Label>
    </div>

    <%-- ===== DETALLE / CARRITO ===== --%>
    <div class="panel-box">
        <h3>Detalle de la venta</h3>

        <asp:Button ID="btnAgregar" runat="server" Text="+ Agregar Producto" CssClass="btn btn-verde"
            OnClick="btnAgregar_Click" CausesValidation="false" />

        <div class="scroll-260" style="margin-top:14px;">
            <asp:GridView ID="dgvDetalle" runat="server" AutoGenerateColumns="false"
                CssClass="grid" GridLines="None" Width="100%"
                OnRowCommand="dgvDetalle_RowCommand">
                <Columns>
                    <asp:BoundField DataField="producto" HeaderText="Producto" />
                    <asp:BoundField DataField="cantidad" HeaderText="Cantidad" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="precioVenta" HeaderText="Precio Unit. (S/)" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="subtotal" HeaderText="Subtotal (S/)" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                    <asp:TemplateField HeaderText="">
                        <ItemTemplate>
                            <asp:Button ID="btnQuitar" runat="server" Text="Quitar" CssClass="btn-mini btn-rojo"
                                CommandName="Quitar" CommandArgument='<%# Eval("producto") %>' CausesValidation="false"
                                OnClientClick="return confirm('¿Quitar este producto del detalle?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding:18px;text-align:center;color:#6B7280;">Aún no hay productos agregados.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <div class="acciones-detalle">
            <asp:Button ID="btnGenerar" runat="server" Text="GENERAR COMPROBANTE" CssClass="btn btn-azul"
                OnClick="btnGenerar_Click" CausesValidation="false" style="padding:12px 26px;" />
            <div class="total-box">
                <span>TOTAL:</span>
                <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control" ReadOnly="true" Text="0.00"></asp:TextBox>
            </div>
        </div>
    </div>

    <%-- ============================================================ --%>
    <%--  MODAL 1: JdSeleccionarProductoVenta                         --%>
    <%-- ============================================================ --%>
    <asp:Panel ID="pnlModalProducto" runat="server" CssClass="modal-overlay" Visible="false">
        <div class="modal-box ancho">
            <div class="modal-header">
                <span>Seleccionar Productos</span>
                <asp:Button ID="btnCerrarProducto" runat="server" Text="✕" CssClass="btn-mini btn-rojo"
                    OnClick="btnCerrarProducto_Click" CausesValidation="false" />
            </div>
            <div class="modal-body">

                <asp:Label ID="lblMsgProducto" runat="server" CssClass="mensaje-exito" Visible="false"></asp:Label>

                <div class="campo" style="max-width:420px;margin-bottom:14px;">
                    <label>Tipo de Producto</label>
                    <asp:DropDownList ID="cboTipoProducto" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnSelectedIndexChanged="cboTipoProducto_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>

                <div class="scroll-260">
                    <asp:GridView ID="dgvProductos" runat="server" AutoGenerateColumns="false"
                        CssClass="grid" GridLines="None" Width="100%"
                        DataKeyNames="idproducto,producto,precioactual,stock" OnRowCommand="dgvProductos_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="producto" HeaderText="Producto" />
                            <asp:BoundField DataField="marcaproducto" HeaderText="Marca" />
                            <asp:BoundField DataField="tipoproducto" HeaderText="Tipo" />
                            <asp:BoundField DataField="precioactual" HeaderText="Precio (S/)" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="stock" HeaderText="Stock" ItemStyle-HorizontalAlign="Center" />
                            <asp:TemplateField HeaderText="Cantidad">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtCantidad" runat="server" CssClass="form-control" Text="1"
                                        Width="60px" style="text-align:center;"></asp:TextBox>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:Button ID="btnAgregarProd" runat="server" Text="Agregar" CssClass="btn-mini btn-verde"
                                        CommandName="AgregarProd" CommandArgument='<%# Eval("idproducto") %>' CausesValidation="false" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div style="padding:18px;text-align:center;color:#6B7280;">No hay productos para este tipo.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div style="display:flex; justify-content:flex-end; margin-top:16px;">
                    <asp:Button ID="btnVolverProducto" runat="server" Text="← Volver a la venta" CssClass="btn btn-azul"
                        OnClick="btnCerrarProducto_Click" CausesValidation="false" />
                </div>

            </div>
        </div>
    </asp:Panel>

    <%-- ============================================================ --%>
    <%--  MODAL 2: JdComprobanteVenta                                 --%>
    <%-- ============================================================ --%>
    <asp:Panel ID="pnlModalComprobante" runat="server" CssClass="modal-overlay" Visible="false">
        <div class="modal-box comprobante">
            <div class="modal-header no-print">
                <span>Comprobante de Pago</span>
                <asp:Button ID="btnCerrarComp" runat="server" Text="✕" CssClass="btn-mini btn-rojo"
                    OnClick="btnCerrarComp_Click" CausesValidation="false" />
            </div>
            <div class="modal-body">

                <asp:Label ID="lblMsgComp" runat="server" Visible="false" CssClass="no-print"></asp:Label>

                <%-- ÁREA IMPRIMIBLE --%>
                <div id="areaImpresion" class="comp-doc">
                    <div class="comp-titulo">
                        <asp:Label ID="lblTipoComp" runat="server" Text="BOLETA DE VENTA"></asp:Label><br />
                        <asp:Label ID="lblNumComp" runat="server"></asp:Label>
                    </div>

                    <div class="comp-row">
                        <div class="campo"><label>Fecha</label>
                            <asp:TextBox ID="txtCompFecha" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                        <div class="campo"><label>Trabajador</label>
                            <asp:TextBox ID="txtCompTrabajador" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                        <div class="campo"><label>Señor(es)</label>
                            <asp:TextBox ID="txtCompCliente" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                        <div class="campo"><label>DNI / RUC</label>
                            <asp:TextBox ID="txtCompDniRuc" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    </div>

                    <table class="grid" style="width:100%;">
                        <thead>
                            <tr><th>Producto</th><th style="text-align:center;">Cant.</th>
                                <th style="text-align:right;">P.Unit.</th><th style="text-align:right;">Subtotal</th></tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptDetalleComp" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("producto") %></td>
                                        <td style="text-align:center;"><%# Eval("cantidad") %></td>
                                        <td style="text-align:right;"><%# Convert.ToDecimal(Eval("precioVenta")).ToString("N2") %></td>
                                        <td style="text-align:right;"><%# Convert.ToDecimal(Eval("subtotal")).ToString("N2") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>

                    <div class="comp-totales">
                        <div class="linea"><span>Op. Gravada (S/)</span>
                            <asp:TextBox ID="txtSubTotal" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                        <div class="linea"><span>IGV 18% (S/)</span>
                            <asp:TextBox ID="txtIgv" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                        <div class="linea"><span><b>TOTAL (S/)</b></span>
                            <asp:TextBox ID="txtCompTotal" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox></div>
                    </div>
                    <div class="comp-son">
                        SON: <asp:Label ID="lblSon" runat="server"></asp:Label>
                    </div>
                </div>

                <%-- CONTROLES DE PAGO (no se imprimen) --%>
                <div class="comp-row no-print" style="margin-top:16px;">
                    <div class="campo"><label>Estado</label>
                        <asp:DropDownList ID="cboEstado" runat="server" CssClass="form-control">
                            <asp:ListItem>Pagado</asp:ListItem>
                            <asp:ListItem>Pendiente</asp:ListItem>
                        </asp:DropDownList></div>
                    <div class="campo"><label>Medio de Pago</label>
                        <asp:DropDownList ID="cboMedioPago" runat="server" CssClass="form-control"
                            AutoPostBack="true" OnSelectedIndexChanged="cboMedioPago_SelectedIndexChanged">
                        </asp:DropDownList></div>
                    <div class="campo"><label>Monto Pagado (S/)</label>
                        <asp:TextBox ID="txtMonto" runat="server" CssClass="form-control"
                            AutoPostBack="true" OnTextChanged="txtMonto_TextChanged"></asp:TextBox></div>
                    <div class="campo"><label>Vuelto (S/)</label>
                        <asp:TextBox ID="txtVuelto" runat="server" CssClass="form-control" ReadOnly="true" Text="0.00"></asp:TextBox></div>
                </div>

                <div class="acciones-detalle no-print">
                    <asp:Button ID="btnGuardarComp" runat="server" Text="Guardar Comprobante" CssClass="btn btn-verde"
                        OnClick="btnGuardarComp_Click" CausesValidation="false" />
                    <asp:Button ID="btnImprimir" runat="server" Text="🖨 Imprimir / Guardar PDF" CssClass="btn btn-azul"
                        Enabled="false" OnClientClick="imprimirComprobante(); return false;" CausesValidation="false" />
                </div>

            </div>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        // Imprime SOLO el comprobante en una ventana nueva aislada
        // (evita las páginas duplicadas que produce el modal con position:fixed)
        function imprimirComprobante() {
            var area = document.getElementById('areaImpresion');
            if (!area) return;
            var contenido = area.innerHTML;
            var estilos =
                '<style>' +
                '* { box-sizing: border-box; }' +
                'body { font-family: Verdana, Arial, sans-serif; font-size: 10pt; color: #111; margin: 0; padding: 24px; }' +
                '.comp-titulo { background: #1F2937; color: #fff; text-align: center; padding: 10px; border-radius: 4px; font-weight: bold; font-size: 13pt; margin-bottom: 16px; }' +
                '.comp-row { display: flex; flex-wrap: wrap; gap: 8px 24px; margin-bottom: 14px; }' +
                '.comp-row .campo { flex: 1 1 45%; display: flex; flex-direction: column; }' +
                'label { font-size: 8.5pt; font-weight: bold; color: #1F2937; margin-bottom: 3px; text-transform: uppercase; }' +
                'input { border: none; background: transparent; font-family: inherit; font-size: 10pt; color: #111; padding: 2px 0; width: 100%; }' +
                'table { width: 100%; border-collapse: collapse; margin: 10px 0; }' +
                'th { background: #1F2937; color: #fff; text-align: left; padding: 7px 9px; font-size: 9pt; }' +
                'td { padding: 6px 9px; border-bottom: 1px solid #ddd; font-size: 9pt; }' +
                '.comp-totales { margin-top: 14px; display: flex; flex-direction: column; align-items: flex-end; gap: 5px; }' +
                '.comp-totales .linea { display: flex; gap: 10px; align-items: center; }' +
                '.comp-totales .linea input { width: 120px; text-align: right; }' +
                '.comp-son { margin-top: 12px; font-style: italic; font-size: 9pt; }' +
                '</style>';
            var v = window.open('', '_blank', 'width=820,height=700');
            if (!v) {
                alert('Permite las ventanas emergentes para imprimir el comprobante.');
                return;
            }
            v.document.write('<html><head><title>Comprobante</title>' + estilos + '</head><body>' + contenido + '</body></html>');
            v.document.close();
            v.focus();
            setTimeout(function () { v.print(); v.close(); }, 350);
        }

        // Filtra las filas de una tabla en vivo (mientras se escribe)
        function filtrarTabla(input, idTabla) {
            var filtro = input.value.toLowerCase();
            var tabla = document.getElementById(idTabla);
            if (!tabla) return;
            var filas = tabla.rows;
            for (var i = 0; i < filas.length; i++) {
                if (filas[i].getElementsByTagName('th').length > 0) continue; // cabecera
                var texto = (filas[i].innerText || filas[i].textContent || "").toLowerCase();
                filas[i].style.display = (texto.indexOf(filtro) > -1) ? "" : "none";
            }
        }
    </script>

</asp:Content>
