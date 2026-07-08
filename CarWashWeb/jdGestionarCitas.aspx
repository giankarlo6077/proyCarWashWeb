<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarCitas.aspx.vb" Inherits="jdGestionarCitas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .barra-volver { margin-bottom: 15px; }
        .btn-volver { background: #6B7280; color: #fff; border: none; border-radius: 4px; padding: 8px 16px; font-size: 9pt; font-weight: bold; cursor: pointer; }
        .btn-volver:hover { background: #4B5563; }

        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 20px; border-radius: 8px; margin-bottom: 20px; font-size: 16pt; font-family: sans-serif; }
        .panel-grid { 
            display: grid;
            /* En lugar de 1fr y 1.5fr, definimos porcentajes exactos basados en el total */
            grid-template-columns: 24% 76%; 
            gap: 20px; 
            width: 100%;
        }
        #<%= upFiltros.ClientID %> {
            display: block;
            width: 100%;
        }
        .panel-box { border: 1px solid #D1D5DB; padding: 20px; background: white; border-radius: 6px; }
        .campo-form { margin-bottom: 15px; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }

        .contenedor-tabla-scroll { max-height: 450px; overflow-y: auto; border: 1px solid #e0e0e0; }

        .grid-estilo { width: 100%; border-collapse: collapse; font-family: 'Segoe UI', sans-serif; font-size: 14px; }
        .grid-estilo th { background-color: #1F2937; color: white; padding: 12px; text-align: left; position: sticky; top: 0; z-index: 1; font-weight: 600; }
        .grid-estilo td { padding: 12px; border-bottom: 1px solid #E5E7EB; color: #333; }

        .btn-base { border: none; padding: 10px 15px; color: white; font-weight: bold; border-radius: 4px; cursor: pointer; font-size: 9pt; }
        .btn-seleccionar { background-color: #1F2937; color: white; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-weight: bold; }
        .btn-buscar { background-color: #1F2937; color: white; padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; }

        /* Específico para el input+botón de placa */
        .input-con-boton { display: flex; gap: 6px; width: 100%; }
        .input-con-boton .form-control { flex: 1 !important; width: auto !important; }

        .lbl-info { display: block; margin-top: 5px; font-size: 11px; font-style: italic; }

        .btn-agregar  { background-color: #059669; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 9pt; }
        .btn-eliminar { background-color: #DC2626; color: white; border: none; padding: 4px 10px; border-radius: 4px; cursor: pointer; font-size: 8pt; font-weight: bold; }

    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="barra-volver">
        <button type="button" class="btn-volver" onclick="window.location.href='FrmMenuPrincipal.aspx'; return false;">⬅️ Volver</button>
    </div>

    <div class="titulo-modulo">
        <h1>GESTIÓN DE CITAS</h1>
    </div>

    <div class="panel-grid">

        <!-- PANEL IZQUIERDO -->
        <div class="panel-box">

            <!-- Fecha y Hora -->
            <div style="display:flex; gap:10px;">
                <div class="campo-form" style="flex:1;">
                    <label>Fecha:</label>
                    <asp:Label ID="lblFecha" runat="server" CssClass="form-control lbl-info" />
                </div>
                <div class="campo-form" style="flex:1;">
                    <label>Hora:</label>
                    <asp:Label ID="lblHora" runat="server" CssClass="form-control lbl-info" />
                </div>
            </div>

            <!-- Placa con botón buscar -->
            <div class="campo-form">
                <label>Placa del Vehículo:</label>
                <div class="input-con-boton">
                    <asp:TextBox ID="txtPlaca" runat="server" CssClass="form-control"
                        placeholder="Ej: ABC-123"
                        style="flex: 1 !important; width: auto !important;" />
                    <asp:Button ID="btnBuscarVehic" runat="server" Text="Buscar"
                        CssClass="btn-buscar" />
                </div>
                <asp:Label ID="lblNombreCliente" runat="server" CssClass="lbl-info"
                    Text="El nombre del cliente aparecerá aquí"
                    style="display:block; color:#9CA3AF; font-style:italic; margin-top:5px;" />
            </div>

            <!-- Trabajador -->
            <div class="campo-form">
                <label>Trabajador:</label>
                <asp:DropDownList ID="cmbTrabajador" runat="server" CssClass="form-control" />
            </div>

            <!-- Comentario -->
            <div class="campo-form">
                <label>Comentario:</label>
                <asp:TextBox ID="txtComentario" runat="server" CssClass="form-control"
                    TextMode="MultiLine" Rows="3" placeholder="Observaciones..." />
            </div>

            <!-- Fecha de Recojo -->
            <div class="campo-form">
                <label>Fecha de Recojo:</label>
                <asp:TextBox ID="dtpFechaRecojo" runat="server" CssClass="form-control"
                    TextMode="Date" />
            </div>

            <!-- Servicios a agregar -->
            <div class="campo-form">
                <label>Servicios:</label>
                <div class="contenedor-tabla-scroll" style="max-height:150px;">
                    <asp:GridView ID="dgvServiciosCita" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid-estilo"
                        GridLines="None"
                        OnRowCommand="dgvServiciosCita_RowCommand"
                        EmptyDataText="No hay servicios agregados.">
                        <Columns>
                            <asp:BoundField DataField="idServicio" HeaderText="ID"       />
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
                    CssClass="btn-agregar" OnClick="btnAgregarServicio_Click"
                    style="margin-top:6px;" />
            </div>

            <!-- Botones -->
            <div style="display:flex; gap:10px;">
                <asp:Button ID="btnGenerarCita" runat="server" Text="GENERAR CITA"
                    CssClass="btn-base" BackColor="#2563EB" />
                <asp:Button ID="btnLimpiar" runat="server" Text="LIMPIAR"
                    CssClass="btn-base" BackColor="#DC2626" />
            </div>

            <asp:Label ID="lblMensaje" runat="server"
                style="display:block; margin-top:10px; font-weight:bold;" />
        </div>

        <!-- PANEL DERECHO -->
        <asp:UpdatePanel ID="upFiltros" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div class="panel-box">
                    <div style="display:flex; gap:10px; margin-bottom:10px; align-items:center;">
                        <asp:DropDownList ID="ddlPeriodo" runat="server" CssClass="form-control"
                            style="width:160px; flex-shrink:0;"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="FiltrarCitas">
                            <asp:ListItem Value=""       Text="Todos los períodos" />
                            <asp:ListItem Value="hoy"    Text="Hoy"                />
                            <asp:ListItem Value="semana" Text="Última semana"      />
                            <asp:ListItem Value="mes"    Text="Último mes"         />
                            <asp:ListItem Value="anio"   Text="Último año"         />
                        </asp:DropDownList>

                        <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control"
                            placeholder="Buscar por placa o comentario..."
                            style="flex:1;"
                            AutoPostBack="true"
                            OnTextChanged="FiltrarCitas" />

                        <asp:Button ID="btnLimpiarFiltro" runat="server" Text="✕ Limpiar"
                            CssClass="btn-buscar" OnClick="btnLimpiarFiltro_Click"
                            style="flex-shrink:0;" />
                    </div>

                    <div class="contenedor-tabla-scroll">
                        <asp:GridView ID="dgvCitas" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="grid-estilo"
                            DataKeyNames="idCita"
                            GridLines="None"
                            OnRowCommand="dgvCitas_RowCommand">
                            <Columns>
                                <asp:BoundField DataField="idCita"      HeaderText="ID"              />
                                <asp:BoundField DataField="fecha"       HeaderText="Fecha"           />
                                <asp:BoundField DataField="hora"        HeaderText="Hora"            />
                                <asp:BoundField DataField="estado"      HeaderText="Estado"          />
                                <asp:BoundField DataField="comentario"  HeaderText="Comentario"      />
                                <asp:BoundField DataField="fechaRecojo" HeaderText="Fecha de Recojo" />
                                <asp:BoundField DataField="placa"       HeaderText="Placa"           />
                                <asp:BoundField DataField="trabajador"  HeaderText="Trabajador"      />
                                <asp:TemplateField HeaderText="Acción">
                                    <ItemTemplate>
                                        <asp:Button ID="btnVer" runat="server" Text="Ver detalle"
                                            CssClass="btn-seleccionar"
                                            CommandName="VerDetalle"
                                            CommandArgument='<%# Eval("idCita") %>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="txtBuscar"        EventName="TextChanged"        />
                <asp:AsyncPostBackTrigger ControlID="ddlPeriodo"       EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="btnLimpiarFiltro" EventName="Click"              />
            </Triggers>
        </asp:UpdatePanel>

    </div>
    
    <script>
        function dispararFiltro(txtId) {
            clearTimeout(window._filtroTimer);
            window._filtroTimer = setTimeout(function () {
                __doPostBack(txtId, '');
            }, 300);
        }

        // Restaurar el foco después de cada actualización del UpdatePanel
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var txt = document.getElementById('<%= txtBuscar.ClientID %>');
        if (txt) {
            // Restaurar foco y posición del cursor al final
            txt.focus();
            var len = txt.value.length;
            txt.setSelectionRange(len, len);
        }
    });
    </script>

    <!-- MODAL SERVICIOS -->
    <div id="modalServicios" class="modal-overlay">
        <div class="modal-box">
            <h3>Seleccionar Servicio</h3>
            <div class="modal-tabla-scroll">
                <asp:GridView ID="dgvSelecServicios" runat="server"
                    AutoGenerateColumns="false" CssClass="grid-estilo"
                    DataKeyNames="idServicio" GridLines="None"
                    OnRowCommand="dgvSelecServicios_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="idServicio" HeaderText="ID"       />
                        <asp:BoundField DataField="servicio"   HeaderText="Servicio" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button runat="server" Text="Seleccionar"
                                    CssClass="btn-seleccionar"
                                    CommandName="ElegirServicio"
                                    CommandArgument='<%# Eval("idServicio") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <asp:Button ID="btnCerrarModalServicio" runat="server" Text="Cerrar"
                CssClass="btn-buscar" OnClick="btnCerrarModalServicio_Click" />
        </div>
    </div>

    <asp:HiddenField ID="hdnMostrarModalServicio" runat="server" Value="0" />

    <!-- CSS del modal -->
    <style>
        .modal-overlay { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.55); z-index:1000; }
        .modal-box { background:white; margin:4% auto; width:600px; max-width:95%; padding:24px; border-radius:8px; }
        .modal-box h3 { margin-top:0; border-left:4px solid #1F2937; padding-left:10px; }
        .modal-tabla-scroll { max-height:320px; overflow-y:auto; border:1px solid #e0e0e0; border-radius:4px; margin-bottom:14px; }
    </style>

    <!-- Script modal -->
    <script>
        window.addEventListener('load', function () {
            if (document.getElementById('<%= hdnMostrarModalServicio.ClientID %>').value === '1') {
                document.getElementById('modalServicios').style.display = 'block';
            }
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            var hdn = document.getElementById('<%= hdnMostrarModalServicio.ClientID %>');
            if (hdn && hdn.value === '1') {
                document.getElementById('modalServicios').style.display = 'block';
            } else {
                document.getElementById('modalServicios').style.display = 'none';
            }

            var txt = document.getElementById('<%= txtBuscar.ClientID %>');
            if (txt) {
                txt.focus();
                var len = txt.value.length;
                txt.setSelectionRange(len, len);
            }
        });

        function dispararFiltro(txtId) {
            clearTimeout(window._filtroTimer);
            window._filtroTimer = setTimeout(function () {
                __doPostBack(txtId, '');
            }, 300);
        }
    </script>

</asp:Content>

