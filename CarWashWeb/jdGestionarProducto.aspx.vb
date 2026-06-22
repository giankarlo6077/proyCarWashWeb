Imports System.Data
Imports capaNegocio

Partial Class jdGestionarProducto
    Inherits System.Web.UI.Page

    Dim objProducto As New clsProducto()
    Dim objMarca As New clsMarca()
    Dim objTipo As New clsTipoProducto()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            listarcbo()
            listar("")
        End If
    End Sub

    '====================== MÉTODOS DE APOYO ======================
    Private Sub listar(ByVal dato As String)
        Try
            dgvProductos.DataSource = objProducto.listarIdNombre(dato)
            dgvProductos.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar productos: " & ex.Message)
        End Try
    End Sub

    Private Sub listarcbo()
        Try
            ' Marcas
            cboMarcaProducto.DataSource = objMarca.listarMarca()
            cboMarcaProducto.DataTextField = "marcaproducto"
            cboMarcaProducto.DataValueField = "idmarcaproducto"
            cboMarcaProducto.DataBind()
            cboMarcaProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))

            ' Tipos
            cboTipoProducto.DataSource = objTipo.listarTipoProducto()
            cboTipoProducto.DataTextField = "tipoproducto"
            cboTipoProducto.DataValueField = "idtipoproducto"
            cboTipoProducto.DataBind()
            cboTipoProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
        Catch ex As Exception
            MostrarError("Error al cargar combos: " & ex.Message)
        End Try
    End Sub

    Private Sub limpiarForm()
        txtId.Text = ""
        txtNombre.Text = ""
        txtStock.Text = "0"
        txtPrecio.Text = ""
        chkVigencia.Checked = True
        cboMarcaProducto.SelectedIndex = 0
        cboTipoProducto.SelectedIndex = 0
    End Sub

    Private Sub SeleccionarPorTexto(ByVal ddl As DropDownList, ByVal texto As String)
        ddl.ClearSelection()
        Dim item As ListItem = ddl.Items.FindByText(texto)
        If item IsNot Nothing Then item.Selected = True
    End Sub

    '====================== ABRIR MODAL: REGISTRAR NUEVO ======================
    Protected Sub btnRegistrarNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnRegistrarNuevo.Click
        Try
            hdnModo.Value = "nuevo"
            limpiarForm()
            txtId.Text = objProducto.generarCodigoProducto().ToString()
            lblFormTitulo.Text = "Registrar Producto"
            pnlForm.Visible = True
            lblMensaje.Text = ""
        Catch ex As Exception
            MostrarError("Error al preparar el registro: " & ex.Message)
        End Try
    End Sub

    '====================== ACCIONES POR FILA (Editar / Dar de baja) ======================
    Protected Sub dgvProductos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        Dim id As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), id) Then Exit Sub

        Select Case e.CommandName
            Case "Editar"
                Try
                    Dim fila As DataRow = objProducto.buscarXid(id)
                    If fila IsNot Nothing Then
                        hdnModo.Value = "editar"
                        txtId.Text = id.ToString()
                        txtNombre.Text = Convert.ToString(fila("producto"))
                        txtStock.Text = Convert.ToString(fila("stock"))
                        chkVigencia.Checked = Convert.ToBoolean(fila("vigencia"))
                        txtPrecio.Text = Convert.ToString(fila("precioactual"))
                        SeleccionarPorTexto(cboMarcaProducto, Convert.ToString(fila("marcaproducto")))
                        SeleccionarPorTexto(cboTipoProducto, Convert.ToString(fila("tipoproducto")))
                        lblFormTitulo.Text = "Modificar Producto"
                        pnlForm.Visible = True
                        lblMensaje.Text = ""
                    End If
                Catch ex As Exception
                    MostrarError("Error al cargar el producto: " & ex.Message)
                End Try

            Case "Baja"
                Try
                    objProducto.darbajaProducto(id)
                    MostrarExito("PRODUCTO DADO DE BAJA")
                    listar("")
                Catch ex As Exception
                    MostrarError("Error al dar de baja: " & ex.Message)
                End Try
        End Select
    End Sub

    '====================== GUARDAR (Registrar o Modificar) ======================
    Protected Sub btnGuardar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnGuardar.Click
        ' Validaciones
        If txtNombre.Text.Trim() = "" Then
            MostrarErrorModal("Ingrese el nombre del producto")
            Exit Sub
        End If
        If cboTipoProducto.SelectedIndex <= 0 Then
            MostrarErrorModal("Seleccione el tipo de producto")
            Exit Sub
        End If
        If cboMarcaProducto.SelectedIndex <= 0 Then
            MostrarErrorModal("Seleccione la marca del producto")
            Exit Sub
        End If
        Dim precio As Decimal
        If Not Decimal.TryParse(txtPrecio.Text, precio) Then
            MostrarErrorModal("Ingrese un precio válido")
            Exit Sub
        End If

        Try
            Dim idMarca As Integer = Convert.ToInt32(cboMarcaProducto.SelectedValue)
            Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
            Dim stock As Integer = Convert.ToInt32(txtStock.Text)

            If hdnModo.Value = "nuevo" Then
                Dim id As Integer = objProducto.generarCodigoProducto()
                objProducto.registrarProducto(id, txtNombre.Text.Trim(), stock, chkVigencia.Checked, precio, idTipo, idMarca)
                MostrarExito("PRODUCTO REGISTRADO")
            Else
                objProducto.modificarProducto(Convert.ToInt32(txtId.Text), txtNombre.Text.Trim(), stock, chkVigencia.Checked, precio, idTipo, idMarca)
                MostrarExito("PRODUCTO MODIFICADO")
            End If

            pnlForm.Visible = False
            limpiarForm()
            listar("")
        Catch ex As Exception
            MostrarErrorModal("Error al guardar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnCancelar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnCancelar.Click
        pnlForm.Visible = False
        limpiarForm()
        lblMensaje.Text = ""
    End Sub

    '====================== MENSAJES ======================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub

    Private Sub MostrarExito(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-exito"
        lblMensaje.Text = mensaje
    End Sub

    ' Si hay error de validación dentro del modal, lo mantenemos abierto y mostramos el aviso
    Private Sub MostrarErrorModal(ByVal mensaje As String)
        pnlForm.Visible = True
        ScriptManagerAlerta(mensaje)
    End Sub

    Private Sub ScriptManagerAlerta(ByVal mensaje As String)
        Dim limpio As String = mensaje.Replace("'", " ").Replace(Chr(10), " ").Replace(Chr(13), " ")
        ClientScript.RegisterStartupScript(Me.GetType(), "alertaModal", "alert('" & limpio & "');", True)
    End Sub

End Class
