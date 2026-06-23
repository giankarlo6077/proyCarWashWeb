<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="JdMantenimientoProveedor.aspx.vb" Inherits="JdMantenimientoProveedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .titulo-modulo {
            background-color: #111827;
            color: white;
            text-align: center;
            padding: 25px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .titulo-modulo h1 {
            margin: 0;
            font-size: 20pt;
            letter-spacing: 0.5px;
        }

        /* ===== BARRA SUPERIOR: BUSCAR + NUEVO ===== */
        .barra-acciones {
            display: flex;
            gap: 12px;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .barra-acciones .buscador {
            display: flex;
            gap: 8px;
            flex: 1;
            min-width: 280px;
        }

        .form-control {
            padding: 9px 12px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }

        .barra-acciones .buscador .form-control {
            flex: 1;
        }

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

        .btn-buscar { background-color: #1F2937; padding: 10px 16px; }
        .btn-buscar:hover { background-color: #374151; }

        .btn-nuevo { background-color: #059669; }
        .btn-nuevo:hover { background-color: #047857; }

        .btn-volver { background-color: #1F2937; }
        .btn-volver:hover { background-color: #374151; }

        /* ===== MODAL CON IFRAME (Gestionar Proveedores encima) ===== */
        .modal-iframe-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(17, 24, 39, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1100;
        }
        .modal-iframe-box {
            background: white;
            width: 1150px;
            max-width: 95%;
            height: 88vh;
            border-radius: 10px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            box-shadow: 0 20px 40px rgba(0,0,0,0.35);
        }
        .modal-iframe-header {
            background: #1F2937;
            color: white;
            padding: 12px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: bold;
            font-size: 12pt;
        }
        .btn-cerrar-iframe {
            background: #DC2626;
            color: white;
            border: none;
            border-radius: 6px;
            width: 34px;
            height: 30px;
            font-size: 12pt;
            cursor: pointer;
        }
        .modal-iframe-frame {
            flex: 1;
            width: 100%;
            border: none;
        }

        /* ===== GRILLA ===== */
        .contenedor-tabla-scroll {
            max-height: 460px;
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 6px;
        }

        .grid-proveedores {
            width: 100%;
            border-collapse: collapse;
            font-size: 9pt;
        }

        .grid-proveedores th {
            background-color: #1F2937;
            color: white;
            padding: 10px;
            text-align: left;
            position: sticky;
            top: 0;
            z-index: 1;
            white-space: nowrap;
        }

        .grid-proveedores td {
            padding: 8px 10px;
            border-bottom: 1px solid #E5E7EB;
            vertical-align: middle;
        }

        .grid-proveedores tr:hover {
            background-color: #F3F4F6;
        }

        .badge-estado {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 8pt;
            font-weight: bold;
        }

        .btn-mini {
            border: none;
            border-radius: 4px;
            padding: 6px 12px;
            font-size: 8pt;
            font-weight: bold;
            cursor: pointer;
            color: white;
            margin-right: 4px;
        }

        /* Botones de acción como iconos */
        .btn-icono {
            border: none;
            border-radius: 6px;
            width: 36px;
            height: 32px;
            font-size: 13pt;
            line-height: 1;
            cursor: pointer;
            color: white;
            margin-right: 5px;
            vertical-align: middle;
            transition: transform 0.1s ease;
        }
        .btn-icono:hover { transform: scale(1.12); }

        .btn-editar { background-color: #2563EB; }
        .btn-editar:hover { background-color: #1D4ED8; }

        .btn-baja { background-color: #DC2626; }
        .btn-baja:hover { background-color: #B91C1C; }

        /* ===== MODAL (frmEditarProveedor) ===== */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(17, 24, 39, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-box {
            background: white;
            width: 620px;
            max-width: 92%;
            border-radius: 10px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            overflow: hidden;
            animation: aparecer 0.18s ease-out;
        }

        @keyframes aparecer {
            from { transform: translateY(-12px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-header {
            background-color: #1F2937;
            color: white;
            padding: 16px 22px;
            font-size: 13pt;
            font-weight: bold;
        }

        .modal-body {
            padding: 22px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .campo-form {
            display: flex;
            flex-direction: column;
        }

        .campo-form.full { grid-column: 1 / -1; }

        .campo-form label {
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
        }

        .campo-form .form-control { width: 100%; }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 22px;
        }

        .btn-guardar { background-color: #059669; padding: 10px 22px; }
        .btn-guardar:hover { background-color: #047857; }

        .btn-cancelar { background-color: #6B7280; padding: 10px 22px; }
        .btn-cancelar:hover { background-color: #4B5563; }

        /* ===== MENSAJES ===== */
        .mensaje-error {
            color: #DC2626;
            background: #FEF2F2;
            border: 1px solid #FECACA;
            font-size: 9pt;
            display: block;
            padding: 10px 14px;
            border-radius: 4px;
            margin-bottom: 16px;
        }

        .mensaje-exito {
            color: #059669;
            background: #ECFDF5;
            border: 1px solid #A7F3D0;
            font-size: 9pt;
            display: block;
            padding: 10px 14px;
            border-radius: 4px;
            margin-bottom: 16px;
        }

        .mensaje-modal {
            color: #DC2626;
            font-size: 9pt;
            display: block;
            margin-bottom: 14px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>MANTENIMIENTO DE PROVEEDORES</h1>
    </div>

    <%-- Mensaje general de la página (éxito / error) --%>
    <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

    <%-- ===== BARRA: BUSCAR (automático) + NUEVO ===== --%>
    <div class="barra-acciones">
        <asp:Button ID="btnVolver" runat="server" Text="← Volver" CssClass="btn btn-volver"
            OnClick="btnVolver_Click" CausesValidation="false" />
        <div class="buscador">
            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control"
                placeholder="🔍 Buscar por proveedor, RUC o contacto..."></asp:TextBox>
        </div>
        <asp:Button ID="btnNuevo" runat="server" Text="+ Nuevo Proveedor" CssClass="btn btn-nuevo"
            OnClientClick="abrirNuevoProveedor(); return false;" CausesValidation="false" />
    </div>

    <%-- ===== GRILLA DE PROVEEDORES ===== --%>
    <div class="contenedor-tabla-scroll">
        <asp:GridView ID="dgvProveedores" runat="server" AutoGenerateColumns="false"
            CssClass="grid-proveedores" GridLines="None" Width="100%"
            DataKeyNames="idProveedor" OnRowCommand="dgvProveedores_RowCommand">
            <Columns>
                <asp:BoundField DataField="proveedor" HeaderText="Proveedor" />
                <asp:BoundField DataField="ruc" HeaderText="RUC" />
                <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                <asp:BoundField DataField="correo" HeaderText="Correo" />
                <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                <asp:BoundField DataField="contacto" HeaderText="Contacto" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class="badge-estado"
                            style='<%# IIf(Eval("estado").ToString() = "Activo", "background:#ECFDF5;color:#059669;", "background:#FEF2F2;color:#DC2626;") %>'>
                            <%# Eval("estado") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:Button ID="btnEditar" runat="server" Text="✏️" ToolTip="Editar" CssClass="btn-icono btn-editar"
                            CommandName="Editar" CommandArgument='<%# Eval("idProveedor") %>' CausesValidation="false" />
                        <asp:Button ID="btnBaja" runat="server" Text="🚫" ToolTip="Dar de baja" CssClass="btn-icono btn-baja"
                            CommandName="Baja" CommandArgument='<%# Eval("idProveedor") %>' CausesValidation="false"
                            OnClientClick="return confirm('¿Está seguro de dar de baja a este proveedor?');" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div style="padding: 25px; text-align: center; color: #6B7280;">
                    No se encontraron proveedores.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </div>

    <%-- ============================================================ --%>
    <%--  MODAL: frmEditarProveedor (Editar Proveedor)                --%>
    <%-- ============================================================ --%>
    <asp:Panel ID="pnlModal" runat="server" CssClass="modal-overlay" Visible="false">
        <div class="modal-box">
            <div class="modal-header">
                <asp:Label ID="lblModalTitulo" runat="server" Text="Editar Proveedor"></asp:Label>
            </div>
            <div class="modal-body">

                <asp:HiddenField ID="hdnIdProveedor" runat="server" Value="0" />

                <asp:Label ID="lblModalMensaje" runat="server" CssClass="mensaje-modal" Visible="false"></asp:Label>

                <div class="form-grid">
                    <div class="campo-form full">
                        <label>Nombre / Razón Social:</label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="campo-form">
                        <label>RUC (11 dígitos):</label>
                        <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                    </div>

                    <div class="campo-form">
                        <label>Teléfono (9 dígitos):</label>
                        <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9"></asp:TextBox>
                    </div>

                    <div class="campo-form full">
                        <label>Correo electrónico:</label>
                        <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                    </div>

                    <div class="campo-form full">
                        <label>Dirección:</label>
                        <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="campo-form">
                        <label>Persona de contacto:</label>
                        <asp:TextBox ID="txtContacto" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>

                    <div class="campo-form">
                        <label>Estado:</label>
                        <asp:DropDownList ID="cboEstado" runat="server" CssClass="form-control">
                            <asp:ListItem Value="Activo">Activo</asp:ListItem>
                            <asp:ListItem Value="Inactivo">Inactivo</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnCancelarModal" runat="server" Text="Cancelar" CssClass="btn btn-cancelar"
                        OnClick="btnCancelarModal_Click" CausesValidation="false" />
                    <asp:Button ID="btnGuardarModal" runat="server" Text="Guardar Cambios" CssClass="btn btn-guardar"
                        OnClick="btnGuardarModal_Click" CausesValidation="false" />
                </div>

            </div>
        </div>
    </asp:Panel>

    <%-- ============================================================ --%>
    <%--  MODAL CON IFRAME: jdGestionarProovedor encima                --%>
    <%-- ============================================================ --%>
    <div id="modalNuevo" class="modal-iframe-overlay" style="display:none;">
        <div class="modal-iframe-box">
            <div class="modal-iframe-header" style="justify-content: flex-end;">
                <button type="button" class="btn-cerrar-iframe" onclick="cerrarNuevoProveedor();">✕</button>
            </div>
            <iframe id="frameNuevo" class="modal-iframe-frame" src="about:blank"></iframe>
        </div>
    </div>

    <script type="text/javascript">
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

        function abrirNuevoProveedor() {
            document.getElementById('frameNuevo').src = 'jdGestionarProovedor.aspx';
            document.getElementById('modalNuevo').style.display = 'flex';
        }
        function cerrarNuevoProveedor() {
            document.getElementById('modalNuevo').style.display = 'none';
            // Recargamos para que la grilla refleje los proveedores registrados
            window.location.reload();
        }
    </script>

</asp:Content>
