<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FrmMenuPrincipal.aspx.vb" Inherits="FrmMenuPrincipal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .bienvenida-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #E5E7EB;
        }

        .bienvenida-header h1 {
            color: #1F2937;
            font-size: 18pt;
            margin: 0 0 5px 0;
        }

        .bienvenida-header h1 .nombre {
            font-weight: bold;
        }

        .bienvenida-header p {
            color: #6B7280;
            font-size: 9pt;
            margin: 0;
        }

        .fecha-hoy {
            background-color: #F3F4F6;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 9pt;
            color: #374151;
            white-space: nowrap;
        }

        /* ===== TARJETAS DE RESUMEN ===== */
        .tarjetas-resumen {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 35px;
        }

        .tarjeta-resumen {
            border-radius: 10px;
            padding: 22px 24px;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .tarjeta-resumen .etiqueta {
            font-size: 8.5pt;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            opacity: 0.85;
            margin-bottom: 8px;
        }

        .tarjeta-resumen .valor {
            font-size: 22pt;
            font-weight: bold;
            line-height: 1;
        }

        .tarjeta-resumen .detalle {
            font-size: 8pt;
            opacity: 0.85;
            margin-top: 6px;
        }

        .tarjeta-ventas { background: linear-gradient(135deg, #1F2937, #374151); }
        .tarjeta-citas-pendientes { background: linear-gradient(135deg, #B45309, #D97706); }
        .tarjeta-citas-hoy { background: linear-gradient(135deg, #1D4ED8, #2563EB); }
        .tarjeta-clientes { background: linear-gradient(135deg, #047857, #059669); }

        /* ===== TABLA DE ÚLTIMAS CITAS ===== */
        .seccion-tabla {
            background-color: white;
            border: 1px solid #E5E7EB;
            border-radius: 10px;
            padding: 22px;
        }

        .seccion-tabla h2 {
            font-size: 12pt;
            color: #1F2937;
            margin: 0 0 18px 0;
        }

        .tabla-citas {
            width: 100%;
            border-collapse: collapse;
            font-size: 9pt;
        }

        .tabla-citas th {
            text-align: left;
            color: #6B7280;
            font-weight: normal;
            font-size: 8pt;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 8px 10px;
            border-bottom: 2px solid #E5E7EB;
        }

        .tabla-citas td {
            padding: 10px 10px;
            border-bottom: 1px solid #F3F4F6;
            color: #374151;
        }

        .badge-estado {
            padding: 3px 10px;
            border-radius: 12px;
            font-size: 7.5pt;
            font-weight: bold;
            color: white;
        }

        .badge-pendiente { background-color: #D97706; }
        .badge-completado { background-color: #059669; }
        .badge-cancelado { background-color: #DC2626; }
        .badge-otro { background-color: #6B7280; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- ===== ENCABEZADO DE BIENVENIDA ===== -->
    <div class="bienvenida-header">
        <div>
            <h1>Bienvenido, <span class="nombre"><asp:Label ID="lblNombreTrabajador" runat="server" Text=""></asp:Label></span></h1>
            <p>Aquí tienes un resumen rápido de la actividad del negocio</p>
        </div>
        <div class="fecha-hoy">
            <asp:Label ID="lblFechaHoy" runat="server" Text=""></asp:Label>
        </div>
    </div>

    <!-- ===== TARJETAS DE RESUMEN ===== -->
    <div class="tarjetas-resumen">

        <div class="tarjeta-resumen tarjeta-ventas">
            <div class="etiqueta">Ventas de Hoy</div>
            <div class="valor">S/ <asp:Label ID="lblTotalVentasHoy" runat="server" Text="0.00"></asp:Label></div>
            <div class="detalle"><asp:Label ID="lblCantidadVentasHoy" runat="server" Text="0"></asp:Label> comprobante(s) emitido(s)</div>
        </div>

        <div class="tarjeta-resumen tarjeta-citas-hoy">
            <div class="etiqueta">Citas de Hoy</div>
            <div class="valor"><asp:Label ID="lblCitasHoy" runat="server" Text="0"></asp:Label></div>
            <div class="detalle">Programadas para el día de hoy</div>
        </div>

        <div class="tarjeta-resumen tarjeta-citas-pendientes">
            <div class="etiqueta">Citas Pendientes</div>
            <div class="valor"><asp:Label ID="lblCitasPendientes" runat="server" Text="0"></asp:Label></div>
            <div class="detalle">En total, sin atender aún</div>
        </div>

        <div class="tarjeta-resumen tarjeta-clientes">
            <div class="etiqueta">Total Clientes</div>
            <div class="valor"><asp:Label ID="lblTotalClientes" runat="server" Text="0"></asp:Label></div>
            <div class="detalle">Registrados en el sistema</div>
        </div>

    </div>

    <!-- ===== ÚLTIMAS CITAS ===== -->
    <div class="seccion-tabla">
        <h2>Últimas Citas Registradas</h2>

        <asp:GridView ID="dgvUltimasCitas" runat="server" AutoGenerateColumns="false"
            CssClass="tabla-citas" GridLines="None" Width="100%">
            <Columns>
                <asp:BoundField DataField="idCita" HeaderText="N° Cita" />
                <asp:BoundField DataField="placa" HeaderText="Placa" />
                <asp:BoundField DataField="fecha" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="hora" HeaderText="Hora" DataFormatString="{0:HH:mm}" />
                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <%# ObtenerBadgeEstado(Eval("estado").ToString()) %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                No hay citas registradas aún.
            </EmptyDataTemplate>
        </asp:GridView>

    </div>

</asp:Content>