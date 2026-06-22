<%@ Page Title="Acerca de Washycar" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdAcercaDe.aspx.vb" Inherits="jdAcercaDe" %>

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

        .contenedor-acercade {
            max-width: 950px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 25px;
            font-family: Verdana, sans-serif;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 25px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        .seccion-titulo {
            font-size: 14pt;
            font-weight: bold;
            color: #1F2937;
            border-bottom: 2px solid #1F2937;
            padding-bottom: 6px;
            margin-bottom: 15px;
            text-transform: uppercase;
        }

        /* Bloque informativo superior */
        .info-empresa h2 {
            font-size: 16pt;
            color: #111827;
            margin: 0 0 10px 0;
        }

        .info-empresa p {
            font-size: 10pt;
            color: #4B5563;
            line-height: 1.6;
            margin: 0 0 20px 0;
        }

        .mision-vision-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }

        .bloque-mv h3 {
            font-size: 11pt;
            font-weight: bold;
            color: #1F2937;
            margin: 0 0 8px 0;
        }

        .bloque-mv p {
            font-size: 9.5pt;
            color: #4B5563;
            line-height: 1.5;
            margin: 0;
        }

        /* Grid de integrantes adaptivo */
        .integrantes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .card-integrante {
            background-color: #F9FAFB;
            border: 1px solid #E5E7EB;
            border-radius: 6px;
            padding: 15px;
            display: flex;
            flex-direction: column;
            gap: 6px;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }

        .card-integrante .rol-lbl {
            font-size: 8.5pt;
            font-weight: bold;
            color: #4B5563;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .card-integrante .nombre-txt {
            font-size: 10.5pt;
            font-weight: bold;
            color: #111827;
        }

        .card-integrante .codigo-txt {
            font-size: 9.5pt;
            color: #6B7280;
        }

        /* Información Técnica */
        .tech-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .tech-item span {
            display: block;
            font-size: 9.5pt;
        }

        .tech-item .tech-label {
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 4px;
        }

        .tech-item .tech-valor {
            color: #4B5563;
        }

        .botonera {
            display: flex;
            justify-content: center;
            margin-top: 10px;
        }

        .btn-cerrar {
            background-color: #FFFFFF;
            color: #000000;
            border: 2px solid #000000;
            border-radius: 4px;
            padding: 10px 30px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.2s;
        }
        .btn-cerrar:hover {
            background-color: #F3F4F6;
        }

        @media (max-width: 768px) {
            .mision-vision-grid, .tech-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contenedor-acercade">
        
        <div class="titulo-modulo">
            <h1>Acerca del Sistema</h1>
        </div>

        <div class="panel-box info-empresa">
            <div class="seccion-titulo">Información de la empresa</div>
            <h2>Washycar</h2>
            <p>Sistema integral de gestión diseñado para optimizar el flujo de trabajo en centros de servicio automotriz.</p>
            
            <div class="mision-vision-grid">
                <div class="bloque-mv">
                    <h3>Misión</h3>
                    <p>Proveer una herramienta tecnológica robusta y eficiente que automatice los procesos administrativos y operativos de los talleres mecánicos, permitiendo a nuestros usuarios enfocarse en la calidad del servicio y la satisfacción de sus clientes.</p>
                </div>
                <div class="bloque-mv">
                    <h3>Visión</h3>
                    <p>Ser la solución de software líder en el sector automotriz, reconocida por impulsar la transformación digital de los talleres y facilitar la toma de decisiones mediante el control preciso de la información.</p>
                </div>
            </div>
        </div>

        <div class="panel-box">
            <div class="seccion-titulo">Integrantes del equipo</div>
            
            <div class="integrantes-grid">
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Edgar Bernabé Villegas</span>
                    <span class="codigo-txt">Código: 231TD34233</span>
                </div>
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Fabian Carrasco Vera</span>
                    <span class="codigo-txt">Código: 231VP33146</span>
                </div>
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Mauricio Vargas Alvarez</span>
                    <span class="codigo-txt">Código: 231VP33069</span>
                </div>
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Leonardo Hernandez Leon</span>
                    <span class="codigo-txt">Código: 231VP32595</span>
                </div>
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Valentino Lopez Barboza</span>
                    <span class="codigo-txt">Código: 231VP33069</span>
                </div>
                <div class="card-integrante">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Jorge Pizarro Uceda</span>
                    <span class="codigo-txt">Código: 181CV78501</span>
                </div>
                <div class="card-integrante" style="grid-column: 1 / -1; max-width: 320px; margin: 0 auto; width: 100%;">
                    <span class="rol-lbl">Desarrollador</span>
                    <span class="nombre-txt">Jesus Chapoñan Paico</span>
                    <span class="codigo-txt">Código: 211AD15481</span>
                </div>
            </div>
        </div>

        <div class="panel-box">
            <div class="seccion-titulo">Información Técnica</div>
            
            <div class="tech-grid">
                <div class="tech-item">
                    <span class="tech-label">Entorno de desarrollo:</span>
                    <span class="tech-valor">Visual Studio (VB.NET / ASP.NET Web Forms)</span>
                </div>
                <div class="tech-item">
                    <span class="tech-label">Motor de Base de Datos:</span>
                    <span class="tech-valor">SQL Server / Somee (Nube)</span>
                </div>
            </div>

            <div class="botonera">
                <asp:Button ID="btnVolver" runat="server" Text="Volver al Menú" CssClass="btn-cerrar" OnClick="btnVolver_Click" CausesValidation="false" />
            </div>
        </div>

    </div>
</asp:Content>