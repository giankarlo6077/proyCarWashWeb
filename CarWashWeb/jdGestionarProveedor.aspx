<%@ Page Title="Gestión de Proveedores" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarProveedor.aspx.vb" Inherits="jdGestionarProveedor" %>

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

        .panel-flex {
            display: flex;
            flex-direction: column;
            gap: 25px;
            align-items: stretch;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 20px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        .contenedor-tabla-scroll {
            max-height: 300px; 
            overflow-y: auto;
            border: 1px solid #E5E7EB;
            border-radius: 4px;
            margin-top: 10px;
        }

        .fila-buscar {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            align-items: center;
        }

        .fila-buscar .form-control {
            flex: 1;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            box-sizing: border-box;
        }

        .btn-nuevo-top {
            background-color: #6B7280;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            cursor: pointer;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
        }
        .btn-nuevo-top:hover { background-color: #4B5563; }

        /* Formulario estructurado en 2 columnas */
        .formulario-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            column-gap: 30px;
            row-gap: 14px;
        }

        .subtitulo-seccion {
            grid-column: span 2;
            font-size: 11pt;
            font-weight: bold;
            color: #1F2937;
            border-bottom: 1px solid #E5E7EB;
            padding-bottom: 6px;
            margin-bottom: 5px;
        }

        .campo-form {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }

        .campo-form label {
            display: block;
            font-size: 9.5pt;
            font-weight: bold;
            color: #1F2937;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            box-sizing: border-box;
            color: #333333;
        }

        .campo-form .form-control:disabled {
            background-color: #F3F4F6;
            color: #6B7280;
            cursor: not-allowed;
        }

        .botonera {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 20px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            cursor: pointer;
            color: white;
            text-transform: uppercase;
        }

        .btn-registrar { background-color: #059669; }
        .btn-registrar:hover { background-color: #047857; }

        .btn-editar { background-color: #2563EB; }
        .btn-editar:hover { background-color: #1D4ED8; }

        .btn-eliminar { background-color: #DC2626; }
        .btn-eliminar:hover { background-color: #B91C1C; }

        .btn-limpiar { 
            background-color: #FFFFFF; 
            color: #1F2937;
            border: 1px solid #D1D5DB;
        }
        .btn-limpiar:hover { background-color: #F9FAFB; }

        .btn-cancelar {
            background-color: #FFFFFF;
            color: #000000;
            border: 2px solid #000000;
        }
        .btn-cancelar:hover { background-color: #F3F4F6; }

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
        .btn-seleccionar:hover { background-color: #374151; }

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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="titulo-modulo">
        <h1>Gestión de Proveedores</h1>
    </div>

    <div class="panel-flex">
        
        <div class="panel-box">
            <div class="fila-buscar">
                <asp:Button ID="btnNuevo" runat="server" Text="Nuevo" CssClass="btn-nuevo-top" OnClick="btnNuevo_Click" CausesValidation="false" />
                <div style="flex: 1;"></div>
                <span style="font-family: Verdana; font-size: 9.5pt; font-weight: bold; color: #1F2937;">Buscar proveedor:</span>
                <asp:TextBox ID="txtBuscarProveedor" runat="server" CssClass="form-control" placeholder="Escriba el nombre del proveedor..." AutoPostBack="true" OnTextChanged="txtBuscarProveedor_TextChanged" style="max-width: 350px;"></asp:TextBox>
            </div>

            <div class="contenedor-tabla-scroll">
               <asp:GridView ID="DataGridView1" runat="server" AutoGenerateColumns="false"
                    CssClass="grid-usuarios" GridLines="None" Width="100%"
                    DataKeyNames="idProveedor" OnRowCommand="DataGridView1_RowCommand" OnRowDataBound="DataGridView1_RowDataBound">
                    <Columns>
                        <asp:BoundField DataField="idProveedor" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="proveedor" HeaderText="Proveedor" />
                        <asp:BoundField DataField="ruc" HeaderText="RUC" />
                        <asp:BoundField DataField="telefono" HeaderText="Teléfono" />
                        <asp:BoundField DataField="correo" HeaderText="Correo" />
                        <asp:BoundField DataField="direccion" HeaderText="Dirección" />
                        <asp:BoundField DataField="contacto" HeaderText="Contacto" />
                        <asp:BoundField DataField="estado" HeaderText="Estado" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSeleccionar" runat="server" Text="Seleccionar" CssClass="btn-seleccionar"
                                    CommandName="SelectRow" 
                                    CommandArgument='<%# Eval("idProveedor") & "|" & Eval("proveedor") & "|" & Eval("ruc") & "|" & Eval("telefono") & "|" & Eval("correo") & "|" & Eval("direccion") & "|" & Eval("contacto") & "|" & Eval("estado") %>' 
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6B7280;">
                            No se encontraron proveedores registrados.
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

        <div class="panel-box">
            <asp:HiddenField ID="hdnIdProveedorSeleccionado" runat="server" Value="0" />

            <div class="formulario-grid">
                <div class="subtitulo-seccion">Datos del nuevo proveedor</div>

                <div class="campo-form">
                    <label>Nombre:</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Correo:</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" TextMode="Email"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>RUC:</label>
                    <asp:TextBox ID="txtRUC" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Dirección:</label>
                    <asp:TextBox ID="txtDireccion" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Teléfono:</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="9"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Persona de contacto:</label>
                    <asp:TextBox ID="txtContacto" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="campo-form" style="grid-column: span 2; max-width: 48.5%;">
                    <label>Estado:</label>
                    <asp:DropDownList ID="cboEstado" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>

            <div class="botonera">
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn-accion btn-registrar" OnClick="btnRegistrar_Click" />
                <asp:Button ID="btnEditar" runat="server" Text="Editar" CssClass="btn-accion btn-editar" OnClick="btnEditar_Click" />
                <asp:Button ID="btnEliminar" runat="server" Text="Eliminar" CssClass="btn-accion btn-eliminar" OnClick="btnEliminar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-accion btn-limpiar" OnClick="btnLimpiar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

    </div>

    <script type="text/javascript">
        function confirmarEliminarProveedor() {
            var id = document.getElementById('<%= hdnIdProveedorSeleccionado.ClientID %>').value;
            if (id === "0") {
                alert("Por favor, seleccione un proveedor de la tabla superior.");
                return false;
            }
            return confirm("¿Desea eliminar definitivamente el proveedor?");
        }
    </script>
</asp:Content>