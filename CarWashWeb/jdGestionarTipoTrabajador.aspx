<%@ Page Title="Gestión de Tipos de Trabajador" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarTipoTrabajador.aspx.vb" Inherits="jdGestionarTipoTrabajador" %>

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

        .panel-grid {
            display: grid;
            grid-template-columns: 1fr 1.3fr;
            gap: 30px;
            align-items: start;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        .contenedor-tabla-scroll {
            max-height: 350px; 
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 4px;
            margin-top: 10px;
        }

        .campo-form {
            margin-bottom: 16px;
        }

        .campo-form label {
            display: block;
            font-size: 9.5pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 8px;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            box-sizing: border-box;
        }

        .botonera {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 18px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
            text-transform: uppercase;
        }

        .btn-nuevo { background-color: #6B7280; }
        .btn-nuevo:hover { background-color: #4B5563; }

        .btn-guardar { background-color: #059669; }
        .btn-guardar:hover { background-color: #047857; }

        .btn-modificar { background-color: #2563EB; }
        .btn-modificar:hover { background-color: #1D4ED8; }

        .btn-cancelar { background-color: #DC2626; }
        .btn-cancelar:hover { background-color: #B91C1C; }

        .btn-limpiar { 
            background-color: #FFFFFF; 
            color: #1F2937;
            border: 1px solid #D1D5DB;
        }
        .btn-limpiar:hover { background-color: #F9FAFB; }

        .btn-cerrar {
            background-color: #FFFFFF;
            color: #000000;
            border: 2px solid #000000;
        }
        .btn-cerrar:hover {
            background-color: #F3F4F6;
        }

        .grid-usuarios {
            width: 100%;
            border-collapse: collapse;
            font-size: 9.5pt;
        }

        .grid-usuarios th {
            background-color: #1F2937;
            color: white;
            padding: 10px;
            text-align: left;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .grid-usuarios td {
            padding: 8px 10px;
            border-bottom: 1px solid #E5E7EB;
        }

        .grid-usuarios tr:hover {
            background-color: #F3F4F6;
        }

        .fila-seleccionada {
            background-color: #E0E7FF !important;
            font-weight: bold;
        }

        .btn-seleccionar {
            background-color: #1F2937;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 5px 12px;
            font-size: 8pt;
            cursor: pointer;
        }

        .btn-seleccionar:hover {
            background-color: #374151;
        }

        .mensaje-error {
            color: #DC2626;
            font-size: 9.5pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9.5pt;
            display: block;
            margin-top: 15px;
            text-align: center;
            font-weight: bold;
        }

        @media (max-width: 900px) {
            .panel-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>Gestión de Tipos de Trabajador</h1>
    </div>

    <div class="panel-grid">
        
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdSeleccionado" runat="server" Value="0" />

            <div class="campo-form">
                <label>Tipo de trabajador:</label>
                <asp:TextBox ID="txtTipoTrabajador" runat="server" CssClass="form-control" placeholder="Ej. Administrador, Lavador, Mecánico..."></asp:TextBox>
            </div>

            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="Nuevo" CssClass="btn-accion btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn-accion btn-guardar" OnClick="btnRegistrar_Click" />
                <asp:Button ID="btnModificar" runat="server" Text="Modificar" CssClass="btn-accion btn-modificar" OnClick="btnModificar_Click" />
                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn-accion btn-cancelar" OnClick="btnEliminar_Click" ContextMode="Server" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-accion btn-limpiar" OnClick="btnLimpiar_Click" CausesValidation="false" />
                <asp:Button ID="btnSalir" runat="server" Text="Salir" CssClass="btn-accion btn-cerrar" OnClick="btnSalir_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

        <div class="panel-box">
            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvTipoTrabajador" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-usuarios" GridLines="None" Width="100%"
                    DataKeyNames="idTipoTrabajador" OnRowCommand="dgvTipoTrabajador_RowCommand" OnRowDataBound="dgvTipoTrabajador_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="idTipoTrabajador" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="tipoTrabajador" HeaderText="Tipo de Trabajador" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                               <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" CssClass="btn-seleccionar"
    CommandName="SelectRow" CommandArgument='<%# Eval("idTipoTrabajador") & "|" & Eval("tipoTrabajador") %>' CausesValidation="false" />

                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">
                            No se encontraron tipos de trabajador registrados.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        function confirmarEliminar() {
            var id = document.getElementById('<%= hdnIdSeleccionado.ClientID %>').value;
            if (id === "0") {
                alert("Por favor, seleccione un registro de la lista.");
                return false;
            }
            return confirm("¿Desea eliminar el registro?");
        }
    </script>
</asp:Content>