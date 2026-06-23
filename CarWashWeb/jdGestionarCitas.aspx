<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarCitas.aspx.vb" Inherits="jdGestionarCitas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .barra-volver { margin-bottom: 15px; }
        .btn-volver { background: #6B7280; color: #fff; border: none; border-radius: 4px; padding: 8px 16px; font-size: 9pt; font-weight: bold; cursor: pointer; }
        .btn-volver:hover { background: #4B5563; }

        .titulo-modulo { background-color: #111827; color: white; text-align: center; padding: 20px; border-radius: 8px; margin-bottom: 20px; font-size: 16pt; font-family: sans-serif; }
        .panel-grid { display: grid; grid-template-columns: 1fr 1.5fr; gap: 20px; }
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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
        <div class="panel-box">

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvCitas" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="grid-estilo"
                    DataKeyNames="idCita"
                    GridLines="None"
                    OnRowCommand="dgvCitas_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="idCita"      HeaderText="ID"         />
                        <asp:BoundField DataField="fecha"       HeaderText="Fecha"      />
                        <asp:BoundField DataField="hora"        HeaderText="Hora"       />
                        <asp:BoundField DataField="estado"        HeaderText="Estado"   />
                        <asp:BoundField DataField="comentario"        HeaderText="Comentario"   />
                        <asp:BoundField DataField="fechaRecojo"        HeaderText="Fecha de Recojo"   />
                        <asp:BoundField DataField="placa"       HeaderText="Placa"   />
                        <asp:BoundField DataField="trabajador"  HeaderText="Trabajador" />
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

    </div>
    

</asp:Content>

