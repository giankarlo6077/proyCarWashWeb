<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdModificarPersona.aspx.vb" Inherits="jdModificarPersona" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* ── Variables de color coherentes con la MasterPage ── */
        :root {
            --azul-oscuro:  #1F2937;
            --azul-medio:   #2563EB;
            --azul-hover:   #1D4ED8;
            --gris-fondo:   #F3F4F6;
            --gris-borde:   #D1D5DB;
            --gris-panel:   #F9FAFB;
            --texto-dark:   #111827;
            --texto-label:  #374151;
            --rojo:         #DC2626;
            --verde:        #16A34A;
            --naranja:      #D97706;
        }

        /* ── Contenedor principal ── */
        .gp-wrapper {
            font-family: Verdana, sans-serif;
            padding: 24px 28px;
            background: var(--gris-fondo);
            min-height: calc(100vh - 80px);
        }

        /* ── Encabezado de página ── */
        .gp-header {
            background: var(--azul-oscuro);
            color: #fff;
            text-align: center;
            padding: 16px 0;
            border-radius: 8px 8px 0 0;
            margin-bottom: 0;
        }
        .gp-header h2 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        /* ── Alerta de mensaje ── */
        .gp-alert {
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 0.82rem;
            font-weight: 600;
            margin-bottom: 14px;
            display: none;   /* se activa por código */
        }
        .gp-alert.error   { background:#FEE2E2; color:var(--rojo);   border:1px solid #FECACA; display:block; }
        .gp-alert.success { background:#DCFCE7; color:var(--verde);  border:1px solid #BBF7D0; display:block; }
        .gp-alert.warning { background:#FEF9C3; color:var(--naranja);border:1px solid #FDE68A; display:block; }

        /* ── Panel de datos ── */
        .gp-card {
            background: #fff;
            border: 1px solid var(--gris-borde);
            border-radius: 0 0 8px 8px;
            padding: 24px 28px 20px;
            margin-bottom: 20px;
        }
        .gp-section-title {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--azul-oscuro);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            border-bottom: 2px solid var(--azul-oscuro);
            padding-bottom: 6px;
            margin-bottom: 18px;
        }

        /* ── Grid de campos ── */
        .gp-field-id {
            display: grid;
            grid-template-columns: 180px;
            gap: 14px;
            margin-bottom: 16px;
        }
        .gp-row-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 14px;
        }
        .gp-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
        }
        .gp-row-4 {
            display: grid;
            grid-template-columns: 1.2fr 1.2fr 1.2fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
            align-items: end;
        }
        .gp-row-dir {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 14px;
            margin-bottom: 14px;
        }

        /* ── Campo ── */
        .gp-field label {
            display: block;
            font-size: 0.76rem;
            font-weight: 700;
            color: var(--texto-label);
            margin-bottom: 5px;
        }
        .gp-field input[type="text"],
        .gp-field input[type="date"],
        .gp-field select,
        .gp-field .asp-input {
            width: 100%;
            padding: 7px 10px;
            border: 1px solid var(--gris-borde);
            border-radius: 5px;
            font-family: Verdana, sans-serif;
            font-size: 0.8rem;
            color: var(--texto-dark);
            background: #fff;
            box-sizing: border-box;
            transition: border-color .2s;
        }
        .gp-field input[type="text"]:focus,
        .gp-field select:focus {
            outline: none;
            border-color: var(--azul-medio);
            box-shadow: 0 0 0 2px rgba(37,99,235,.15);
        }
        .gp-field input[readonly],
        .gp-field input[disabled] {
            background: var(--gris-panel);
            color: #6B7280;
            cursor: not-allowed;
        }

        /* ── Sexo checkboxes ── */
        .gp-sexo-group {
            margin-bottom: 16px;
        }
        .gp-sexo-group label.group-label {
            display: block;
            font-size: 0.76rem;
            font-weight: 700;
            color: var(--texto-label);
            margin-bottom: 8px;
        }
        .gp-sexo-options {
            display: flex;
            gap: 28px;
            align-items: center;
        }
        .gp-sexo-options label {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 0.82rem;
            color: var(--texto-dark);
            cursor: pointer;
            font-weight: 600;
        }
        .gp-sexo-options input[type="checkbox"] {
            width: 16px;
            height: 16px;
            accent-color: var(--azul-medio);
            cursor: pointer;
        }

        /* ── Panel GridView ── */
        .gp-grid-panel {
            background: #fff;
            border: 1px solid var(--gris-borde);
            border-radius: 8px;
            padding: 16px 18px;
            margin-bottom: 20px;
            overflow-x: auto;
        }
        .gp-grid-panel .gp-section-title {
            margin-bottom: 12px;
        }

        /* ── GridView ── */
        .gp-gridview {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.78rem;
        }
        .gp-gridview th {
            background: var(--azul-oscuro);
            color: #fff;
            padding: 9px 10px;
            text-align: left;
            font-weight: 700;
            font-size: 0.74rem;
            letter-spacing: 0.3px;
        }
        .gp-gridview td {
            padding: 8px 10px;
            border-bottom: 1px solid #E5E7EB;
            color: var(--texto-dark);
            vertical-align: middle;
        }
        .gp-gridview tr:hover td {
            background: #EFF6FF;
            cursor: pointer;
        }
        .gp-gridview tr.selected-row td {
            background: #DBEAFE;
            font-weight: 600;
        }
        .gp-gridview .pager td {
            padding: 8px 4px;
            text-align: center;
            background: var(--gris-panel);
        }

        /* ── Botones de acción ── */
        .gp-actions {
            display: flex;
            justify-content: center;
            gap: 14px;
            padding: 4px 0 8px;
        }
        .btn-gp {
            padding: 9px 26px;
            border: none;
            border-radius: 5px;
            font-family: Verdana, sans-serif;
            font-size: 0.82rem;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s, transform .1s;
            letter-spacing: 0.3px;
        }
        .btn-gp:active { transform: scale(.97); }

        .btn-modificar  { background: var(--azul-oscuro); color: #fff; }
        .btn-modificar:hover  { background: #111827; }

        .btn-eliminar   { background: var(--rojo);        color: #fff; }
        .btn-eliminar:hover   { background: #B91C1C; }

        .btn-limpiar    { background: #6B7280;             color: #fff; }
        .btn-limpiar:hover    { background: #4B5563; }

        .btn-cancelar   { background: #E5E7EB;             color: var(--texto-dark); border: 1px solid var(--gris-borde); }
        .btn-cancelar:hover   { background: #D1D5DB; }

        /* ASP.NET controls — anular width:auto por defecto */
        .gp-field .asp-textbox,
        .gp-field .asp-ddl {
            width: 100% !important;
            box-sizing: border-box;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true" />

    <div class="gp-wrapper">

        <!-- Encabezado -->
        <div class="gp-header">
            <h2>Gestionar Persona</h2>
        </div>

        <!-- Mensaje de alerta -->
        <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" />

        <!-- ══ PANEL DE DATOS PERSONALES ══ -->
        <div class="gp-card">
            <div class="gp-section-title">Datos Personales</div>

            <!-- ID Cliente (solo lectura) -->
            <div class="gp-field-id">
                <div class="gp-field">
                    <label for="txtIdCliente">Id Cliente</label>
                    <asp:TextBox ID="txtIdCliente" runat="server" CssClass="asp-textbox"
                        ReadOnly="true" TabIndex="-1" />
                </div>
            </div>

            <!-- Nombres + DNI -->
            <div class="gp-row-2">
                <div class="gp-field">
                    <label for="txtNombreAp">Nombres y Apellidos <span style="color:var(--rojo)">*</span></label>
                    <asp:TextBox ID="txtNombreAp" runat="server" CssClass="asp-textbox"
                        MaxLength="150" placeholder="Ingrese nombres y apellidos" />
                </div>
                <div class="gp-field">
                    <label for="txtDNI">N° DNI <span style="color:var(--rojo)">*</span></label>
                    <asp:TextBox ID="txtDNI" runat="server" CssClass="asp-textbox"
                        MaxLength="8" placeholder="Ingrese el DNI" />
                </div>
            </div>

            <!-- Dirección + Correo + Teléfono -->
            <div class="gp-row-3">
                <div class="gp-field">
                    <label for="txtDireccion">Dirección</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="asp-textbox"
                        MaxLength="200" placeholder="Dirección" />
                </div>
                <div class="gp-field">
                    <label for="txtCorreo">Correo</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="asp-textbox"
                        MaxLength="100" placeholder="correo@ejemplo.com" />
                </div>
                <div class="gp-field">
                    <label for="txtTelefono">Teléfono</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="asp-textbox"
                        MaxLength="15" placeholder="999 999 999" />
                </div>
            </div>

            <!-- Ubigeo + Fecha de Nacimiento -->
            <asp:UpdatePanel ID="upUbigeo" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="gp-row-4">
                        <div class="gp-field">
                            <label for="cboDepartamento">Departamento <span style="color:var(--rojo)">*</span></label>
                            <asp:DropDownList ID="cboDepartamento" runat="server" CssClass="asp-ddl"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="cboDepartamento_SelectedIndexChanged" />
                        </div>
                        <div class="gp-field">
                            <label for="cboProvincia">Provincia <span style="color:var(--rojo)">*</span></label>
                            <asp:DropDownList ID="cboProvincia" runat="server" CssClass="asp-ddl"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="cboProvincia_SelectedIndexChanged" />
                        </div>
                        <div class="gp-field">
                            <label for="cboDistrito">Distrito <span style="color:var(--rojo)">*</span></label>
                            <asp:DropDownList ID="cboDistrito" runat="server" CssClass="asp-ddl" />
                        </div>
                        <div class="gp-field">
                            <label for="txtFechaNac">Fecha de Nacimiento <span style="color:var(--rojo)">*</span></label>
                            <asp:TextBox ID="txtFechaNac" runat="server" CssClass="asp-textbox"
                                TextMode="Date" />
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>

            <!-- Sexo -->
            <div class="gp-sexo-group">
                <label class="group-label">Sexo <span style="color:var(--rojo)">*</span></label>
                <div class="gp-sexo-options">
                    <label>
                        <asp:CheckBox ID="chkMasculino" runat="server"
                            OnCheckedChanged="chkMasculino_CheckedChanged" AutoPostBack="true" />
                        Masculino
                    </label>
                    <label>
                        <asp:CheckBox ID="chkFemenino" runat="server"
                            OnCheckedChanged="chkFemenino_CheckedChanged" AutoPostBack="true" />
                        Femenino
                    </label>
                </div>
            </div>
        </div>
        <%-- /gp-card --%>

        <!-- ══ GRID DE PERSONAS ══ -->
        <div class="gp-grid-panel">
            <div class="gp-section-title">Listado de Personas Registradas</div>
            <asp:GridView ID="gvPersonas" runat="server"
                CssClass="gp-gridview"
                AutoGenerateColumns="false"
                AllowPaging="true"
                PageSize="8"
                OnPageIndexChanging="gvPersonas_PageIndexChanging"
                OnSelectedIndexChanged="gvPersonas_SelectedIndexChanged"
                DataKeyNames="idcliente"
                EmptyDataText="No hay personas registradas."
                OnRowDataBound="gvPersonas_RowDataBound">

                <Columns>
                    <asp:BoundField DataField="idcliente"       HeaderText="ID"               ItemStyle-Width="55px" />
                    <asp:BoundField DataField="persona"         HeaderText="Nombres y Apellidos" ItemStyle-Width="220px" />
                    <asp:BoundField DataField="sexo"            HeaderText="Sexo"             ItemStyle-Width="55px" />
                    <asp:BoundField DataField="numDocumento"    HeaderText="DNI"              ItemStyle-Width="90px" />
                    <asp:BoundField DataField="direccion"       HeaderText="Dirección"        ItemStyle-Width="170px" />
                    <asp:BoundField DataField="correo"          HeaderText="Correo"           ItemStyle-Width="160px" />
                    <asp:BoundField DataField="telefono"        HeaderText="Teléfono"         ItemStyle-Width="90px" />
                    <asp:BoundField DataField="fechaNacimiento" HeaderText="F. Nacimiento"    ItemStyle-Width="100px"
                        DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" />
                    <asp:ButtonField ButtonType="Button" CommandName="Select"
                        Text="Seleccionar"
                        ControlStyle-CssClass="btn-gp btn-modificar"
                        ItemStyle-Width="95px" />
                </Columns>

                <PagerStyle CssClass="pager" HorizontalAlign="Center" />
                <SelectedRowStyle CssClass="selected-row" />
                <EmptyDataRowStyle ForeColor="#6B7280" Font-Italic="true" />
            </asp:GridView>
        </div>

        <!-- ══ BOTONES DE ACCIÓN ══ -->
        <div class="gp-actions">
            <asp:Button ID="btnModificar" runat="server" Text="Modificar"
                CssClass="btn-gp btn-modificar"
                OnClick="btnModificar_Click"
                OnClientClick="return confirmarAccion('¿Desea guardar los cambios de esta persona?');" />

            <asp:Button ID="btnEliminar" runat="server" Text="Eliminar"
                CssClass="btn-gp btn-eliminar"
                OnClick="btnEliminar_Click"
                OnClientClick="return confirmarAccion('¿Está seguro de ELIMINAR esta persona? Esta acción no se puede deshacer.');" />

            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"
                CssClass="btn-gp btn-limpiar"
                OnClick="btnLimpiar_Click" />

            <asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                CssClass="btn-gp btn-cancelar"
                OnClick="btnCancelar_Click" />
        </div>

    </div>

</asp:Content>

