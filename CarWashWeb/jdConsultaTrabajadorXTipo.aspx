<%@ Page Title="Consulta por Tipo" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdConsultaTrabajadorXTipo.aspx.vb" Inherits="jdConsultaTrabajadorXTipo" %>

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
            text-transform: uppercase;
        }

        .contenedor-consulta {
            max-width: 1000px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        /* Fila de Filtros superior adaptada de la imagen */
        .fila-filtros {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }

        .lbl-filtro {
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            font-weight: bold;
            color: #1F2937;
        }

        .form-control {
            padding: 8px 12px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            min-width: 250px;
            box-sizing: border-box;
        }

        /* Botones de acción planos acordes al menú */
        .btn-web {
            border: none;
            border-radius: 4px;
            padding: 9px 22px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.2s;
        }

        .btn-buscar {
            background-color: #1F2937;
            color: white;
        }
        .btn-buscar:hover {
            background-color: #374151;
        }

        .btn-mostrar {
            background-color: #FFFFFF;
            color: #1F2937;
            border: 1px solid #1F2937;
        }
        .btn-mostrar:hover {
            background-color: #F3F4F6;
        }

        /* Contenedor de la Tabla con Scroll */
        .contenedor-tabla-scroll {
            max-height: 380px; 
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 4px;
            margin-top: 15px;
        }

        .grid-consulta {
            width: 100%;
            border-collapse: collapse;
            font-size: 9.5pt;
            font-family: Verdana, sans-serif;
            background-color: #FFFFFF;
        }

        /* Inyección de padding a las celdas autogeneradas */
        .grid-consulta th, .grid-consulta td {
            padding: 10px 14px !important;
            border-bottom: 1px solid #E5E7EB;
            text-align: left;
            vertical-align: middle;
        }

        /* Fijar cabecera con scroll */
        .grid-consulta th {
            position: sticky;
            top: 0;
            z-index: 1;
            background-color: #1F2937 !important;
            color: white !important;
        }

        .grid-consulta tr:hover {
            background-color: #F3F4F6;
        }

        /* Fila de resumen inferior (Contador + Botón Cerrar) */
        .fila-inferior {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 10px;
        }

        .lbl-total {
            font-family: Verdana, sans-serif;
            font-size: 10pt;
            font-weight: bold;
            color: #1F2937;
        }

        .btn-cerrar {
            background-color: #FFFFFF;
            color: #000000;
            border: 2px solid #000000;
            padding: 9px 24px;
        }
        .btn-cerrar:hover {
            background-color: #F3F4F6;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 9.5pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contenedor-consulta">
        
        <div class="titulo-modulo">
            <h1>Consulta Trabajador Por Tipo</h1>
        </div>

        <div class="panel-box">
            
            <div class="fila-filtros">
                <span class="lbl-filtro">Tipo de trabajador:</span>
                <asp:DropDownList ID="cboTipoTrabajador" runat="server" CssClass="form-control"></asp:DropDownList>
                
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn-web btn-buscar" OnClick="btnBuscar_Click" />
                <asp:Button ID="btnMostrarTodos" runat="server" Text="Mostrar Todos" CssClass="btn-web btn-mostrar" OnClick="btnMostrarTodos_Click" />
            </div>

            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvTrabajadores" runat="server" AutoGenerateColumns="true"
                    CssClass="grid-consulta" GridLines="None" Width="100%"
                    OnRowDataBound="dgvTrabajadores_RowDataBound">
    
                    <%-- Estilos embebidos de control de celdas para columnas autogeneradas --%>
                    <HeaderStyle BackColor="#1F2937" ForeColor="White" Height="40px" Font-Bold="true" HorizontalAlign="Left" />
                    <RowStyle Height="38px" BackColor="#FFFFFF" ForeColor="#333333" />
                    <AlternatingRowStyle BackColor="#F9FAFB" />
    
                    <EmptyDataTemplate>
                        <div style="padding: 25px; text-align: center; color: #6B7280; font-weight: bold; font-family: Verdana;">
                            No se encontraron registros de trabajadores para el filtro seleccionado.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <div class="fila-inferior">
                <asp:Label ID="lblTotal" runat="server" Text="Total trabajadores: 0" CssClass="lbl-total"></asp:Label>
                <asp:Button ID="btnCerrar" runat="server" Text="Cerrar" CssClass="btn-web btn-cerrar" OnClick="btnCerrar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

    </div>
</asp:Content>