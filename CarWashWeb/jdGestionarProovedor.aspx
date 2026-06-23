<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarProovedor.aspx.vb" Inherits="jdGestionarProovedor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Cuando la página se abre dentro del modal (iframe), ocultamos el encabezado --%>
    <script type="text/javascript">
        if (window.self !== window.top) {
            document.documentElement.className += ' embed-modal';
        }
    </script>
    <style>
        .embed-modal .navbar,
        .embed-modal .banner-hero { display: none !important; }
        .embed-modal .contenedor-principal { margin: 0 auto; box-shadow: none; min-height: 0; }

        .titulo-modulo {
            background-color: #111827;
            color: white;
            text-align: center;
            padding: 22px 20px;
            border-radius: 8px;
            margin-bottom: 22px;
        }
        .titulo-modulo h1 { margin: 0; font-size: 19pt; }

        /* Esta pantalla se muestra dentro del modal (iframe): ocultamos
           el navbar y el banner de la MasterPage para que se vea limpia */
        .navbar, .banner-hero { display: none !important; }
        .contenedor-principal { margin: 18px auto !important; }

        .panel-grid {
            display: grid;
            grid-template-columns: 1fr 1.25fr;
            gap: 26px;
            align-items: start;
        }

        .panel-box {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 20px;
            background: #FFFFFF;
        }
        .panel-box h3 {
            margin: 0 0 16px 0;
            font-size: 12pt;
            color: #1F2937;
            border-left: 4px solid #1F2937;
            padding-left: 10px;
        }

        .campo-form { margin-bottom: 14px; }
        .campo-form label {
            display: block;
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
        }
        .form-control {
            width: 100%;
            padding: 9px 11px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            box-sizing: border-box;
        }
        .form-control:disabled { background-color: #F3F4F6; color: #6B7280; }

        .botonera {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 18px;
        }
        .btn {
            border: none; border-radius: 4px; padding: 10px 16px;
            font-weight: bold; font-family: Verdana, sans-serif; font-size: 9pt;
            cursor: pointer; color: white;
        }
        .btn:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn-nuevo { background-color: #6B7280; }
        .btn-nuevo:hover:enabled { background-color: #4B5563; }
        .btn-registrar { background-color: #059669; }
        .btn-registrar:hover:enabled { background-color: #047857; }
        .btn-editar { background-color: #2563EB; }
        .btn-editar:hover:enabled { background-color: #1D4ED8; }
        .btn-eliminar { background-color: #DC2626; }
        .btn-eliminar:hover:enabled { background-color: #B91C1C; }
        .btn-limpiar { background-color: #9CA3AF; }
        .btn-volver { background-color: #1F2937; }

        .fila-buscar { display: flex; gap: 10px; margin-bottom: 12px; }
        .fila-buscar .form-control { flex: 1; }
        .btn-buscar { background-color: #1F2937; padding: 9px 14px; }

        .contenedor-tabla-scroll {
            max-height: 460px; overflow-y: auto;
            border: 1px solid #E5E7EB; border-radius: 6px;
        }
        .grid { width: 100%; border-collapse: collapse; font-size: 9pt; }
        .grid th {
            background-color: #1F2937; color: white; padding: 9px 10px;
            text-align: left; position: sticky; top: 0; z-index: 1; white-space: nowrap;
        }
        .grid td { padding: 7px 10px; border-bottom: 1px solid #E5E7EB; }
        .grid tr:hover { background-color: #F3F4F6; }
        .btn-sel { background-color: #1F2937; color: white; border: none;
            border-radius: 4px; padding: 5px 12px; font-size: 8pt; cursor: pointer; }

        .mensaje-error { color:#DC2626; background:#FEF2F2; border:1px solid #FECACA;
            font-size:9pt; display:block; padding:10px 14px; border-radius:4px; margin-bottom:14px; }
        .mensaje-exito { color:#059669; background:#ECFDF5; border:1px solid #A7F3D0;
            font-size:9pt; display:block; padding:10px 14px; border-radius:4px; margin-bottom:14px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>GESTIONAR PROVEEDORES</h1>
    </div>

    <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

    <div class="panel-grid">

        <%-- ===== FORMULARIO ===== --%>
        <div class="panel-box">
            <h3>Datos del proveedor</h3>

            <asp:HiddenField ID="hdnId" runat="server" Value="0" />

            <div class="campo-form">
                <label>Nombre / Razón Social</label>
                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>RUC (11 dígitos)</label>
                <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" MaxLength="11" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>Teléfono (9 dígitos)</label>
                <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>Correo electrónico</label>
                <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>Dirección</label>
                <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>Persona de contacto</label>
                <asp:TextBox ID="txtContacto" runat="server" CssClass="form-control" Enabled="false"></asp:TextBox>
            </div>
            <div class="campo-form">
                <label>Estado</label>
                <asp:DropDownList ID="cboEstado" runat="server" CssClass="form-control" Enabled="false">
                    <asp:ListItem>Activo</asp:ListItem>
                    <asp:ListItem>Inactivo</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="Nuevo" CssClass="btn btn-nuevo"
                    OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn btn-registrar"
                    OnClick="btnRegistrar_Click" CausesValidation="false" Enabled="false" />
                <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="btn btn-editar"
                    OnClick="btnEditar_Click" CausesValidation="false" Enabled="false" />
                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn btn-eliminar"
                    OnClick="btnEliminar_Click" CausesValidation="false" Enabled="false"
                    OnClientClick="return confirm('¿Desea eliminar definitivamente el proveedor?');" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-limpiar"
                    OnClick="btnLimpiar_Click" CausesValidation="false" />
                <asp:Button ID="btnVolver" runat="server" Text="Volver" CssClass="btn btn-volver"
                    OnClick="btnVolver_Click" OnClientClick="return volverGestionar();" CausesValidation="false" />
            </div>
        </div>

        <%-- ===== GRILLA ===== --%>
        <div class="panel-box">
            <h3>Lista de proveedores</h3>

            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscarProveedor" runat="server" CssClass="form-control"
                    placeholder="🔍 Buscar proveedor..."></asp:TextBox>
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvProveedores" runat="server" AutoGenerateColumns="false"
                    CssClass="grid" GridLines="None" Width="100%"
                    DataKeyNames="idProveedor" OnRowCommand="dgvProveedores_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="proveedor" HeaderText="Proveedor" />
                        <asp:BoundField DataField="ruc" HeaderText="RUC" />
                        <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="estado" HeaderText="Estado" />
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnSel" runat="server" Text="Seleccionar" CssClass="btn-sel"
                                    CommandName="Seleccionar" CommandArgument='<%# Eval("idProveedor") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding:25px;text-align:center;color:#6B7280;">No se encontraron proveedores.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
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

        // Si esta página se muestra dentro del iframe modal de Mantenimiento,
        // "Volver" cierra ese modal en vez de navegar dentro del marco.
        function volverGestionar() {
            if (window.self !== window.top && parent.cerrarNuevoProveedor) {
                parent.cerrarNuevoProveedor();
                return false; // evita el postback/redirect del servidor
            }
            return true; // página normal → ejecuta btnVolver_Click (redirect)
        }
    </script>
</asp:Content>
