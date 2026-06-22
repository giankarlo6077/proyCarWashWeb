<%@ Page Title="Gestión de Trabajador" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarTrabajador.aspx.vb" Inherits="jdGestionarTrabajador" %>

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

        .contenedor-formulario {
            max-width: 850px;
            margin: 0 auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .panel-box {
            border: 1px dashed #D1D5DB;
            border-radius: 6px;
            padding: 30px;
            background-color: #FFFFFF;
            box-sizing: border-box;
        }

        /* Diseño de rejilla de dos columnas idéntica a la imagen */
        .formulario-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            column-gap: 30px;
            row-gap: 18px;
            align-items: end;
        }

        /* Fila de ancho completo para Nombre y Correo */
        .ancho-completo {
            grid-column: span 2;
        }

        .campo-form {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .campo-form label {
            display: block;
            font-size: 9.5pt;
            font-weight: bold;
            color: #1F2937;
        }

        .campo-form .form-control {
            width: 100%;
            padding: 9px 12px;
            border: 1px solid #D1D5DB;
            border-radius: 4px;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            box-sizing: border-box;
            color: #333333;
        }

        .campo-form .form-control:disabled, 
        .campo-form .form-control[readonly] {
            background-color: #F3F4F6;
            color: #6B7280;
            cursor: not-allowed;
        }

        /* Fila compuesta para Tipo de trabajador + Botón Gestionar */
        .grupo-combobox {
            display: flex;
            gap: 8px;
            width: 100%;
        }

        .grupo-combobox .form-control {
            flex: 1;
        }

        .btn-gestionar {
            background-color: #111827;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 0 14px;
            cursor: pointer;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9pt;
            height: 38px;
            white-space: nowrap;
            transition: background-color 0.2s;
        }

        .btn-gestionar:hover {
            background-color: #374151;
        }

        .campo-checkbox {
            display: flex;
            align-items: center;
            gap: 8px;
            height: 38px; /* Alineación vertical con el combo de al lado */
        }

        .campo-checkbox label {
            font-size: 9.5pt;
            color: #1F2937;
            font-weight: bold;
            margin: 0;
            cursor: pointer;
        }

        .botonera {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 25px;
            border-top: 1px solid #F3F4F6;
            padding-top: 20px;
        }

        .btn-accion {
            border: none;
            border-radius: 4px;
            padding: 10px 24px;
            font-weight: bold;
            font-family: Verdana, sans-serif;
            font-size: 9.5pt;
            cursor: pointer;
            color: white;
            text-transform: uppercase;
            min-width: 120px;
            transition: background-color 0.2s;
        }

        .btn-guardar { background-color: #0F172A; }
        .btn-guardar:hover { background-color: #334155; }

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

        .mensaje-error {
            color: #DC2626;
            font-size: 9.5pt;
            display: block;
            margin-top: 20px;
            text-align: center;
            font-weight: bold;
        }

        .mensaje-exito {
            color: #059669;
            font-size: 9.5pt;
            display: block;
            margin-top: 20px;
            text-align: center;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="contenedor-formulario">
        
        <div class="titulo-modulo">
            <h1>Registrar Trabajador</h1>
        </div>

        <div class="panel-box">
            <div class="formulario-grid">
                
                <div class="campo-form">
                    <label>Código:</label>
                    <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Tipo de trabajador:</label>
                    <div class="grupo-combobox">
                        <asp:DropDownList ID="cboTipoTrabajador" runat="server" CssClass="form-control"></asp:DropDownList>
                        <asp:Button ID="btnGestionar" runat="server" Text="Gestionar" CssClass="btn-gestionar" OnClick="btnGestionar_Click" CausesValidation="false" />
                    </div>
                </div>

                <div class="campo-form">
                    <label>Estado:</label>
                    <div class="campo-checkbox">
                        <asp:CheckBox ID="chkActivo" runat="server" Text="Activo" />
                    </div>
                </div>

                <div class="campo-form">
                    <label>Sexo:</label>
                    <asp:DropDownList ID="cboSexo" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>

                <div class="campo-form ancho-completo">
                    <label>Nombre:</label>
                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Nombre completo..."></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>DNI:</label>
                    <asp:TextBox ID="txtDNI" runat="server" CssClass="form-control" placeholder="8 dígitos..." MaxLength="8"></asp:TextBox>
                </div>

                <div class="campo-form">
                    <label>Teléfono:</label>
                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" placeholder="9 dígitos..." MaxLength="9"></asp:TextBox>
                </div>

                <div class="campo-form ancho-completo">
                    <label>Correo:</label>
                    <asp:TextBox ID="txtCorreo" runat="server" CssClass="form-control" placeholder="ejemplo@correo.com..." TextMode="Email"></asp:TextBox>
                </div>

            </div>

            <div class="botonera">
                <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" CssClass="btn-accion btn-guardar" OnClick="btnRegistrar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn-accion btn-limpiar" OnClick="btnLimpiar_Click" CausesValidation="false" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn-accion btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Text=""></asp:Label>
        </div>

    </div>
</asp:Content>