<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarTipoProducto.aspx.vb" Inherits="jdGestionarTipoProducto" %>

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

        .campo-form { margin-bottom: 16px; }
        .campo-form label { display: block; font-size: 9pt; font-weight: bold; color: #1F2937; margin-bottom: 5px; }
        .campo-form .form-control { width: 100%; padding: 8px 10px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .campo-form .form-control:focus { outline: none; border-color: #1F2937; }
        .campo-form .form-control:disabled, .campo-form .form-control[readonly] { background-color: #F3F4F6; color: #6B7280; }

        .toolbar { display: flex; gap: 10px; align-items: center; justify-content: space-between; margin-bottom: 15px; flex-wrap: wrap; }
        .toolbar .form-control { flex: 1; min-width: 240px; padding: 9px 12px; border: 1px solid #D1D5DB; border-radius: 4px; font-family: Verdana, sans-serif; font-size: 9pt; box-sizing: border-box; }
        .toolbar .form-control:focus { outline: none; border-color: #1F2937; }

        .btn-accion { border: none; border-radius: 4px; padding: 10px 18px; font-weight: bold; font-family: Verdana, sans-serif; font-size: 9pt; cursor: pointer; color: white; }
        .btn-nuevo { background-color: #059669; } .btn-nuevo:hover { background-color: #047857; }
        .btn-guardar { background-color: #059669; } .btn-guardar:hover { background-color: #047857; }
        .btn-cancelar { background-color: #DC2626; } .btn-cancelar:hover { background-color: #B91C1C; }

        .col-accion { white-space: nowrap; text-align: center; width: 110px; }
        .btn-icono { display: inline-block; width: 34px; height: 30px; line-height: 30px; padding: 0; text-align: center; font-size: 11pt; border: none; border-radius: 4px; cursor: pointer; color: white; margin: 0 2px; vertical-align: middle; }
        .btn-icono.editar { background-color: #2563EB; } .btn-icono.editar:hover { background-color: #1D4ED8; }
        .btn-icono.eliminar { background-color: #DC2626; } .btn-icono.eliminar:hover { background-color: #B91C1C; }

        .grid-modulo { width: 100%; border-collapse: collapse; font-size: 9pt; }
        .grid-modulo th { background-color: #1F2937; color: white; padding: 10px; text-align: left; position: sticky; top: 0; z-index: 1; }
        .grid-modulo td { padding: 8px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid-modulo tr:hover { background-color: #F3F4F6; }

        .mensaje-error { color: #DC2626; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }
        .mensaje-exito { color: #059669; font-size: 9pt; display: block; margin-top: 15px; text-align: center; }

        .modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(17,24,39,.55); display: flex; align-items: center; justify-content: center; z-index: 1000; }
        .modal-card { background: #fff; border-radius: 8px; padding: 26px; width: 440px; max-width: 92%; max-height: 90vh; overflow-y: auto; box-shadow: 0 10px 40px rgba(0,0,0,.3); }
        .modal-card h3 { margin: 0 0 18px 0; font-size: 13pt; color: #1F2937; border-bottom: 2px solid #E5E7EB; padding-bottom: 10px; }
        .modal-botonera { display: flex; gap: 10px; justify-content: flex-end; margin-top: 22px; }
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
        <h1>GESTIÓN DE TIPOS DE PRODUCTO</h1>
        <p>Registra, edita y elimina los tipos (categorías) de productos</p>
    </div>

    <div class="panel-box">

        <div class="toolbar">
            <input type="text" id="txtFiltro" class="form-control" placeholder="🔍 Buscar tipo de producto por id o nombre..." onkeyup="filtrarTabla('txtFiltro','dgvTipos');" />
            <asp:Button ID="btnRegistrarNuevo" runat="server" Text="➕ Registrar Nuevo" CssClass="btn-accion btn-nuevo" CausesValidation="false" />
        </div>

        <div class="contenedor-tabla-scroll">
            <asp:GridView ID="dgvTipos" runat="server" AutoGenerateColumns="false" ClientIDMode="Static"
                CssClass="grid-modulo" GridLines="None" Width="100%"
                DataKeyNames="idtipoproducto" OnRowCommand="dgvTipos_RowCommand">
                <Columns>
                    <asp:BoundField DataField="idtipoproducto" HeaderText="ID" />
                    <asp:BoundField DataField="tipoproducto" HeaderText="Nombre" />
                    <asp:TemplateField HeaderText="Acción">
                        <HeaderStyle CssClass="col-accion" />
                        <ItemStyle CssClass="col-accion" />
                        <ItemTemplate>
                            <asp:Button ID="btnEditar" runat="server" Text="✏️" ToolTip="Modificar" CssClass="btn-icono editar"
                                CommandName="Editar" CommandArgument='<%# Eval("idtipoproducto") %>' CausesValidation="false" />
                            <asp:Button ID="btnEliminar" runat="server" Text="🗑️" ToolTip="Eliminar" CssClass="btn-icono eliminar"
                                CommandName="Quitar" CommandArgument='<%# Eval("idtipoproducto") %>' CausesValidation="false"
                                OnClientClick="return confirm('¿Eliminar este tipo de producto?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div style="padding: 20px; text-align: center; color: #6B7280;">No se encontraron tipos de producto.</div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
    </div>

    <!-- ===== Modal (Registrar / Modificar) ===== -->
    <asp:Panel ID="pnlForm" runat="server" CssClass="modal-overlay" Visible="false">
        <div class="modal-card">
            <h3><asp:Label ID="lblFormTitulo" runat="server" Text="Registrar Tipo de Producto"></asp:Label></h3>

            <asp:HiddenField ID="hdnModo" runat="server" Value="nuevo" />

            <div class="campo-form">
                <label>ID Tipo de Producto:</label>
                <asp:TextBox ID="txtIdTipoProducto" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="campo-form">
                <label>Nombre:</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="modal-botonera">
                <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar" CssClass="btn-accion btn-guardar" CausesValidation="false" />
                <asp:Button ID="btnCancelar" runat="server" Text="✖️ Cancelar" CssClass="btn-accion btn-cancelar" CausesValidation="false" />
            </div>
        </div>
    </asp:Panel>

</asp:Content>
