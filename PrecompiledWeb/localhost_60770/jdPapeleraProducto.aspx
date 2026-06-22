<%@ page title="" language="VB" masterpagefile="~/MasterPage.master" autoeventwireup="false" inherits="jdPapeleraProducto, App_Web_0fjqdpnu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .barra-volver { margin-bottom: 15px; }
        .btn-volver { background: #6B7280; color: #fff; border: none; border-radius: 4px; padding: 8px 16px; font-size: 9pt; font-weight: bold; cursor: pointer; }
        .btn-volver:hover { background: #4B5563; }

        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 25px 20px; border-radius: 8px; margin-bottom: 25px; }
        .titulo-modulo h1 { margin: 0; font-size: 20pt; letter-spacing: 0.5px; }
        .titulo-modulo p { margin: 6px 0 0 0; font-size: 9pt; color: #9CA3AF; }

        .panel-box { border: 1px dashed #D1D5DB; border-radius: 6px; padding: 20px; background-color: #FFFFFF; }

        .contenedor-tabla-scroll { max-height: 480px; overflow-y: auto; border: 1px solid #E5E7EB; border-radius: 4px; margin-top: 10px; }

        .toolbar { display: flex; gap: 10px; align-items: center; justify-content: space-between; margin-bottom: 15px; flex-wrap: wrap; }
        .toolbar .form-control { flex: 1; min-width: 240px; padding: 9px 12px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .toolbar .form-control:focus { outline: none; border-color: #1F2937; }

        .btn-accion { border: none; border-radius: 4px; padding: 10px 18px; font-weight: bold; font-family: Verdana, sans-serif; font-size: 9pt; cursor: pointer; color: white; }
        .btn-secundario { background-color: #4B5563; } .btn-secundario:hover { background-color: #374151; }

        /* Columna Acción: tamaño fijo y sin salto de línea (evita que se apilen) */
        .col-accion { white-space: nowrap; text-align: center; width: 110px; }
        .btn-icono { display: inline-block; width: 34px; height: 30px; line-height: 30px; padding: 0; text-align: center; font-size: 11pt; border: none; border-radius: 4px; cursor: pointer; color: white; margin: 0 2px; vertical-align: middle; }
        .btn-icono.recuperar { background-color: #059669; } .btn-icono.recuperar:hover { background-color: #047857; }
        .btn-icono.eliminar { background-color: #DC2626; } .btn-icono.eliminar:hover { background-color: #B91C1C; }

        .grid-modulo { width: 100%; border-collapse: collapse; font-size: 9pt; }
        .grid-modulo th { background-color: #1F2937; color: white; padding: 10px; text-align: left; position: sticky; top: 0; z-index: 1; }
        .grid-modulo td { padding: 8px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid-modulo tr:hover { background-color: #F3F4F6; }

        .mensaje-error { color: #DC2626; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }
        .mensaje-exito { color: #059669; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }
    </style>

    <script type="text/javascript">
        function filtrarTabla(inputId, tablaId) {
            var filtro = document.getElementById(inputId).value.toLowerCase();
            var tabla = document.getElementById(tablaId);
            if (!tabla) return;
            var filas = tabla.rows;
            for (var i = 1; i < filas.length; i++) {
                filas[i].style.display = (filas[i].innerText.toLowerCase().indexOf(filtro) > -1) ? '' : 'none';
            }
        }
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="barra-volver">
        <button type="button" class="btn-volver" onclick="window.location.href='jdGestionarProducto.aspx'; return false;">⬅️ Volver</button>
    </div>

    <div class="titulo-modulo">
        <h1>PAPELERA DE PRODUCTOS</h1>
        <p>Recupera o elimina definitivamente los productos dados de baja</p>
    </div>

    <div class="panel-box">

        <div class="toolbar">
            <input type="text" id="txtFiltro" class="form-control" placeholder="🔍 Buscar producto por id, nombre, tipo o marca..." onkeyup="filtrarTabla('txtFiltro','dgvPapelera');" />
            <asp:Button ID="btnActualizar" runat="server" Text="🔄 Actualizar" CssClass="btn-accion btn-secundario" CausesValidation="false" />
        </div>

        <div class="contenedor-tabla-scroll">
            <asp:GridView ID="dgvPapelera" runat="server" AutoGenerateColumns="false" ClientIDMode="Static"
                CssClass="grid-modulo" GridLines="None" Width="100%"
                DataKeyNames="idproducto" OnRowCommand="dgvPapelera_RowCommand">
                <Columns>
                    <asp:BoundField DataField="idproducto" HeaderText="Id" />
                    <asp:BoundField DataField="producto" HeaderText="Nombre" />
                    <asp:BoundField DataField="stock" HeaderText="Stock" />
                    <asp:BoundField DataField="precioactual" HeaderText="Precio" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="tipoproducto" HeaderText="Tipo Producto" />
                    <asp:BoundField DataField="marcaproducto" HeaderText="Marca" />
                    <asp:TemplateField HeaderText="Acción">
                        <HeaderStyle CssClass="col-accion" />
                        <ItemStyle CssClass="col-accion" />
                        <ItemTemplate>
                            <asp:Button ID="btnRecuperar" runat="server" Text="♻️" ToolTip="Recuperar" CssClass="btn-icono recuperar"
                                CommandName="Recuperar" CommandArgument='<%# Eval("idproducto") %>' CausesValidation="false" />
                            <asp:Button ID="btnEliminar" runat="server" Text="🗑️" ToolTip="Eliminar definitivo" CssClass="btn-icono eliminar"
                                CommandName="Quitar" CommandArgument='<%# Eval("idproducto") %>' CausesValidation="false"
                                OnClientClick="return confirm('¿Realmente quiere eliminar definitivamente este producto?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 20px; text-align: center; color: #6B7280;">La papelera está vacía.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
    </div>

</asp:Content>
