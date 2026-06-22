<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="FrmMenuPrincipal.aspx.vb" Inherits="FrmMenuPrincipal" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .bienvenida-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            min-height: 400px;
            padding: 40px 20px;
        }

        .bienvenida-container .icono-saludo {
            font-size: 40pt;
            margin-bottom: 10px;
        }

        .bienvenida-container h1 {
            color: #1F2937;
            font-size: 20pt;
            margin: 0 0 8px 0;
        }

        .bienvenida-container h1 .nombre {
            color: #1F2937;
            font-weight: bold;
        }

        .bienvenida-container p.subtitulo {
            color: #6B7280;
            font-size: 10pt;
            margin: 0;
        }

        .bienvenida-container .fecha-hoy {
            margin-top: 25px;
            background-color: #F3F4F6;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 9pt;
            color: #374151;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="bienvenida-container">
        <h1>Bienvenido, <span class="nombre"><asp:Label ID="lblNombreTrabajador" runat="server" Text=""></asp:Label></span></h1>
        <p class="subtitulo">Selecciona una opción del menú superior para comenzar a trabajar en el sistema</p>

        <div class="fecha-hoy">
            <asp:Label ID="lblFechaHoy" runat="server" Text=""></asp:Label>
        </div>
    </div>

</asp:Content>

