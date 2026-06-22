<%@ Page Title="Gestión de Vehículos" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="jdGestionarVehiculo.aspx.vb" Inherits="jdGestionarVehiculo" %>

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
        
        .panel-grid { 
            display: grid; 
            grid-template-columns: 1fr 1.5fr; 
            gap: 20px; 
        }
        
        .panel-box { 
            border: 1px solid #D1D5DB; 
            padding: 20px; 
            background-color: #FFFFFF; 
            border-radius: 6px; 
        }
        
        .campo-form { 
            margin-bottom: 15px; 
        }
        
        .campo-form label {
            display: block;
            font-size: 9pt;
            font-weight: bold;
            color: #1F2937;
            margin-bottom: 5px;
            font-family: Verdana, sans-serif;
        }
        
        .form-control { 
            width: 100%; 
            padding: 8px 10px; 
            border: 1px solid #D1D5DB; 
            border-radius: 4px; 
            box-sizing: border-box; 
            font-family: Verdana, sans-serif;
            font-size: 9pt;
        }
        
        /* Contenedor del scroll */
        .contenedor-tabla-scroll { 
            max-height: 450px; 
            overflow-y: auto; 
            border: 1px solid #E5E7EB; 
            border-radius: 4px;
        }

        /* TABLA LIMPIA: Sin separadores verticales, fuente Verdana */
        .grid-estilo { 
            width: 100%; 
            border-collapse: collapse; 
            font-family: Verdana, sans-serif; 
            font-size: 9pt; 
        }
        
        .grid-estilo th { 
            background-color: #1F2937; 
            color: white; 
            padding: 12px; 
            text-align: left; 
            position: sticky; 
            top: 0; 
            z-index: 1; 
            font-weight: normal; 
        }
        
        .grid-estilo td { 
            padding: 10px 12px; 
            border-bottom: 1px solid #E5E7EB; 
            color: #333; 
        }
        
        .grid-estilo tr:hover {
            background-color: #F3F4F6;
        }
        
        /* Botones generales */
        .botonera { display: flex; gap: 10px; margin-top: 15px; flex-wrap: wrap; justify-content: center; }
        
        .btn-base { 
            border: none; 
            padding: 10px 15px; 
            color: white; 
            font-weight: bold; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 9pt; 
            font-family: Verdana, sans-serif;
        }
        
        .btn-nuevo { background-color: #6B7280; }
        .btn-modificar { background-color: #2563EB; }
        .btn-guardar { background-color: #059669; }
        .btn-cancelar { background-color: #DC2626; }
        
        .btn-seleccionar { 
            background-color: #1F2937; 
            color: white; 
            border: none; 
            padding: 6px 12px; 
            border-radius: 4px; 
            cursor: pointer; 
            font-size: 8pt; 
            font-family: Verdana, sans-serif;
        }
        
        .btn-seleccionar:hover { background-color: #374151; }
        
        .fila-buscar { display: flex; gap: 10px; margin-bottom: 15px; }
        .btn-buscar { background-color: #1F2937; color: white; padding: 0 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 11pt; }
        
        .mensaje-notificacion { display:block; margin-top:15px; font-weight:bold; font-family: Verdana, sans-serif; font-size: 9pt; text-align: center; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="titulo-modulo">GESTIÓN DE VEHÍCULOS</div>
    <div class="panel-grid">
        
        <div class="panel-box">
            <asp:HiddenField ID="hdnIdVehiculo" runat="server" Value="0" />
            
            <div class="campo-form">
                <label>Placa:</label>
                <asp:TextBox ID="txtPlaca" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="campo-form">
                <label>DNI Dueño:</label>
                <asp:TextBox ID="txtDni" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="campo-form">
                <label>Año Fabricación:</label>
                <asp:TextBox ID="txtAño" runat="server" CssClass="form-control"></asp:TextBox>
            </div>
            
            <div class="campo-form">
                <label>Modelo:</label>
                <asp:DropDownList ID="cboModelo" runat="server" CssClass="form-control"></asp:DropDownList>
            </div>
            
            <div class="botonera">
                <asp:Button ID="btnNuevo" runat="server" Text="NUEVO" CssClass="btn-base btn-nuevo" OnClick="btnNuevo_Click" CausesValidation="false" />
                <asp:Button ID="btnModificar" runat="server" Text="MODIFICAR" CssClass="btn-base btn-modificar" OnClick="btnModificar_Click" CausesValidation="false" />
                <asp:Button ID="btnGuardar" runat="server" Text="GUARDAR" CssClass="btn-base btn-guardar" OnClick="btnGuardar_Click" CausesValidation="false" />
                <asp:Button ID="btnCancelar" runat="server" Text="CANCELAR" CssClass="btn-base btn-cancelar" OnClick="btnCancelar_Click" CausesValidation="false" />
            </div>
            
            <asp:Label ID="lblMensaje" runat="server" CssClass="mensaje-notificacion"></asp:Label>
        </div>

        <div class="panel-box">
            <div class="fila-buscar">
                <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Buscar por placa..." AutoPostBack="true" OnTextChanged="txtBuscar_TextChanged"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="🔍" CssClass="btn-buscar" OnClick="btnBuscar_Click" CausesValidation="false" />
            </div>
            
            <div class="contenedor-tabla-scroll">
                <asp:GridView ID="dgvVehiculos" runat="server" AutoGenerateColumns="false" 
                    CssClass="grid-estilo" DataKeyNames="ID" 
                    GridLines="None" 
                    OnRowCommand="dgvVehiculos_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Placa" HeaderText="Placa" />
                        <asp:BoundField DataField="Modelo" HeaderText="Modelo" />
                        <asp:BoundField DataField="DNI" HeaderText="DNI" />
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:Button ID="btnSel" runat="server" Text="Seleccionar" CssClass="btn-seleccionar" CommandName="Seleccionar" CommandArgument='<%# Eval("ID") %>' CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        
    </div>
</asp:Content>