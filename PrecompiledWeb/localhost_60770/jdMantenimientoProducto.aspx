<%@ page title="" language="VB" masterpagefile="~/MasterPage.master" autoeventwireup="false" inherits="jdMantenimientoProducto, App_Web_0fjqdpnu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .barra-volver { margin-bottom: 15px; }
        .btn-volver { background: #6B7280; color: #fff; border: none; border-radius: 4px; padding: 8px 16px; font-size: 9pt; font-weight: bold; cursor: pointer; }
        .btn-volver:hover { background: #4B5563; }

        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 25px 20px; border-radius: 8px; margin-bottom: 25px; }
        .titulo-modulo h1 { margin: 0; font-size: 20pt; letter-spacing: 0.5px; }
        .titulo-modulo p { margin: 6px 0 0 0; font-size: 9pt; color: #9CA3AF; }

        .panel-grid { display: grid; grid-template-columns: 1fr 1.3fr; gap: 30px; align-items: start; }
        .panel-grid.una-columna { grid-template-columns: 1fr; }

        .panel-box { border: 1px dashed #D1D5DB; border-radius: 6px; padding: 20px; background-color: #FFFFFF; }
        .panel-box h3 { margin: 0 0 18px 0; font-size: 11pt; color: #1F2937; border-bottom: 2px solid #E5E7EB; padding-bottom: 8px; }

        .contenedor-tabla-scroll { max-height: 440px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; margin-top: 10px; }

        .campo-form { margin-bottom: 16px; }
        .campo-form label { display: block; font-size: 9pt; font-weight: bold; color: #1F2937; margin-bottom: 5px; }
        .campo-form .form-control { width: 100%; padding: 8px 10px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .campo-form .form-control:focus { outline: none; border-color: #1F2937; }
        .campo-form .form-control:disabled, .campo-form .form-control[readonly] { background-color: #F3F4F6; color: #6B7280; }

        .campo-checkbox { display: flex; align-items: center; gap: 8px; margin-top: 5px; margin-bottom: 8px; }
        .campo-checkbox label { font-size: 9pt; color: #1F2937; font-weight: normal; margin: 0; }

        .fila-buscar { display: flex; gap: 10px; margin-bottom: 15px; }
        .fila-buscar .form-control { flex: 1; padding: 8px 10px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .btn-buscar { background-color: #1F2937; color: white; border: none; border-radius: 4px; padding: 0 16px; cursor: pointer; font-size: 11pt; }
        .btn-buscar:hover { background-color: #374151; }

        .botonera { display: flex; gap: 10px; flex-wrap: wrap; justify-content: flex-end; margin-top: 25px; }
        .botonera.izquierda { justify-content: flex-start; }
        .btn-accion { border: none; border-radius: 4px; padding: 10px 18px; font-weight: bold; font-family: Verdana, sans-serif; font-size: 9pt; cursor: pointer; color: white; }
        .btn-nuevo { background-color: #6B7280; } .btn-nuevo:hover { background-color: #4B5563; }
        .btn-buscar-2 { background-color: #0EA5E9; } .btn-buscar-2:hover { background-color: #0284C7; }
        .btn-modificar { background-color: #2563EB; } .btn-modificar:hover { background-color: #1D4ED8; }
        .btn-guardar { background-color: #059669; } .btn-guardar:hover { background-color: #047857; }
        .btn-limpiar { background-color: #D97706; } .btn-limpiar:hover { background-color: #B45309; }
        .btn-eliminar { background-color: #DC2626; } .btn-eliminar:hover { background-color: #B91C1C; }
        .btn-recuperar { background-color: #059669; } .btn-recuperar:hover { background-color: #047857; }
        .btn-secundario { background-color: #4B5563; } .btn-secundario:hover { background-color: #374151; }

        .enlaces-modulo { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 18px; border-top: 1px solid #E5E7EB; padding-top: 16px; }
        .btn-enlace { background-color: #EEF2FF; color: #1F2937; border: 1px solid #C7D2FE; border-radius: 4px; padding: 8px 14px; font-size: 9pt; font-weight: bold; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn-enlace:hover { background-color: #E0E7FF; }

        .grid-modulo { width: 100%; border-collapse: collapse; font-size: 9pt; }
        .grid-modulo th { background-color: #1F2937; color: white; padding: 10px; text-align: left; position: sticky; top: 0; z-index: 1; }
        .grid-modulo td { padding: 8px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid-modulo tr:hover { background-color: #F3F4F6; }
        .btn-seleccionar { background-color: #1F2937; color: white; border: none; border-radius: 4px; padding: 5px 12px; font-size: 8pt; cursor: pointer; }
        .btn-seleccionar:hover { background-color: #374151; }

        .estado-si { color: #059669; font-weight: bold; }
        .estado-no { color: #DC2626; font-weight: bold; }

        .mensaje-error { color: #DC2626; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }
        .mensaje-exito { color: #059669; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }

        @media (max-width: 900px) { .panel-grid { grid-template-columns: 1fr; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="barra-volver">
        <button type="button" class="btn-volver" onclick="window.location.href='FrmMenuPrincipal.aspx'; return false;">⬅️ Volver</button>
    </div>

    <div class="titulo-modulo">
        <h1>MANTENIMIENTO DE PRODUCTOS</h1>
        <p>Consulta los productos vigentes del sistema</p>
    </div>

    <div class="panel-grid una-columna">

        <div class="panel-box">

            <div class="fila-buscar">
                <asp:TextBox ID="txtbuscador" runat="server" CssClass="form-control" placeholder="Buscar por ID o nombre del producto..."></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" CausesValidation="false" />
                <asp:Button ID="btnGestionar" runat="server" Text="⚙️ Gestionar Productos" CssClass="btn-accion btn-modificar" CausesValidation="false" />
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvProductos" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-modulo" GridLines="None" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="idproducto" HeaderText="Id" />
                        <asp:BoundField DataField="producto" HeaderText="Nombre" />
                        <asp:BoundField DataField="stock" HeaderText="Stock" />
                        <asp:TemplateField HeaderText="Vigencia">
                            <ItemTemplate>
                                <%# IIf(Convert.ToBoolean(Eval("vigencia")), "<span class='estado-si'>Sí</span>", "<span class='estado-no'>No</span>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="precioactual" HeaderText="Precio" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="tipoproducto" HeaderText="Tipo Producto" />
                        <asp:BoundField DataField="marcaproducto" HeaderText="Marca" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">No se encontraron productos.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

    </div>
</asp:Content>
