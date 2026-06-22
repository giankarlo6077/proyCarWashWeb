<%@ Page Title="Historial de Vehículos" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdReporteVehiculo.aspx.vb" Inherits="jdReporteVehiculo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Tipografía general forzada a Verdana */
        .titulo-modulo { 
            background-color: #1F2937; 
            color: white; 
            text-align: center; 
            padding: 20px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            font-size: 16pt; 
            font-family: Verdana, sans-serif; 
            font-weight: bold;
        }
        
        .panel-box { 
            border: 1px solid #D1D5DB; 
            padding: 25px; 
            background-color: #FFFFFF; 
            border-radius: 6px; 
            max-width: 1000px;
            margin: 0 auto; /* Centra el panel en pantallas grandes */
        }
        
        .fila-buscar { 
            display: flex; 
            gap: 15px; 
            align-items: center; 
            margin-bottom: 20px; 
        }
        
        .fila-buscar label {
            font-size: 10pt;
            font-weight: bold;
            color: #1F2937;
            font-family: Verdana, sans-serif;
            white-space: nowrap;
        }
        
        .form-control { 
            width: 300px; 
            padding: 10px 12px; 
            border: 1px solid #D1D5DB; 
            border-radius: 4px; 
            box-sizing: border-box; 
            font-family: Verdana, sans-serif;
            font-size: 10pt;
        }
        
        .btn-buscar { 
            background-color: #1F2937; 
            color: white; 
            padding: 9px 20px; 
            border: none; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 11pt; 
            font-family: Verdana, sans-serif;
        }
        
        .btn-buscar:hover { background-color: #374151; }
        
        /* Contenedor del scroll de la tabla */
        .contenedor-tabla-scroll { 
            max-height: 550px; 
            overflow-y: auto; 
            border: 1px solid #E5E7EB; 
            border-radius: 4px;
        }

        /* TABLA LIMPIA: Sin separadores verticales, fuente Verdana */
        .grid-estilo { 
            width: 100%; 
            border-collapse: collapse; 
            font-family: Verdana, sans-serif; 
            font-size: 9.5pt; 
        }
        
        .grid-estilo th { 
            background-color: #1F2937; 
            color: white; 
            padding: 14px 12px; 
            text-align: left; 
            position: sticky; 
            top: 0; 
            z-index: 1; 
            font-weight: normal; 
        }
        
        .grid-estilo td { 
            padding: 12px; 
            border-bottom: 1px solid #E5E7EB; 
            color: #333; 
        }
        
        .grid-estilo tr:hover {
            background-color: #F3F4F6;
        }
        
        .mensaje-notificacion { 
            display: block; 
            margin-top: 15px; 
            font-weight: bold; 
            font-family: Verdana, sans-serif; 
            font-size: 9.5pt; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="titulo-modulo">CONSULTA DEL HISTORIAL DEL VEHÍCULO</div>
    
    <div class="panel-box">
        <div class="fila-buscar">
            <label>Buscar por placa:</label>
            <asp:TextBox ID="txtPlaca" runat="server" CssClass="form-control" placeholder="Ej: ABC-123" AutoPostBack="true" OnTextChanged="txtPlaca_TextChanged"></asp:TextBox>
            <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
        </div>
        
        <div class="contenedor-tabla-scroll">
            <asp:GridView ID="dgvHistorial" runat="server" AutoGenerateColumns="true" CssClass="grid-estilo" GridLines="None">
                <EmptyDataTemplate>
                    <div style="padding: 30px; text-align: center; color: #6B7280; font-size: 10pt;">
                        No se encontró historial para mostrar.
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        
        <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje-notificacion"></asp:Label>
    </div>
</asp:Content>