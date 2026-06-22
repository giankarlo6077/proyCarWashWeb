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
            btnNuevo.Text = "➕ Nuevo"
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

    Private Sub limpiar()
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

    '====================== BOTONERA ======================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        If txtId.Text.Trim() = "" Then
            MostrarError("Ingrese un ID para buscar")
            Exit Sub
        End If
        Try
            Dim fila As DataRow = objProducto.buscarXid(Convert.ToInt32(txtId.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("producto"))
                txtStock.Text = Convert.ToString(fila("stock"))
                chkVigencia.Checked = Convert.ToBoolean(fila("vigencia"))
                txtPrecio.Text = Convert.ToString(fila("precioactual"))
                SeleccionarPorTexto(cboMarcaProducto, Convert.ToString(fila("marcaproducto")))
                SeleccionarPorTexto(cboTipoProducto, Convert.ToString(fila("tipoproducto")))
                lblMensaje.Text = ""
            Else
                MostrarError("No se encontró el producto con ese ID")
            End If
        Catch ex As Exception
            MostrarError("Error al buscar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnNuevo.Click
        If btnNuevo.Text.Contains("Nuevo") Then
            btnNuevo.Text = "💾 Guardar"
            limpiar()
            Try
                txtId.Text = objProducto.generarCodigoProducto().ToString()
                MostrarExito("Complete los datos del producto y presione Guardar.")
            Catch ex As Exception
                MostrarError("Error al generar el código del producto: " & ex.Message)
            End Try
        Else
            ' Validaciones
            If txtNombre.Text.Trim() = "" Then
                MostrarError("Ingrese el nombre del producto")
                Exit Sub
            End If
            If cboTipoProducto.SelectedIndex <= 0 Then
                MostrarError("Seleccione el tipo de producto")
                Exit Sub
            End If
            If cboMarcaProducto.SelectedIndex <= 0 Then
                MostrarError("Seleccione la marca del producto")
                Exit Sub
            End If
            Dim precio As Decimal
            If Not Decimal.TryParse(txtPrecio.Text, precio) Then
                MostrarError("Ingrese un precio válido")
                Exit Sub
            End If

            btnNuevo.Text = "➕ Nuevo"
            Try
                Dim id As Integer = objProducto.generarCodigoProducto()
                Dim idMarca As Integer = Convert.ToInt32(cboMarcaProducto.SelectedValue)
                Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
                objProducto.registrarProducto(id, txtNombre.Text.Trim(), Convert.ToInt32(txtStock.Text), chkVigencia.Checked, precio, idTipo, idMarca)
                MostrarExito("PRODUCTO REGISTRADO")
                limpiar()
            Catch ex As Exception
                MostrarError("Error al registrar: " & ex.Message)
            End Try
            listar("")
        End If
    End Sub

    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnModificar.Click
        If txtId.Text.Trim() = "" Then
            MostrarError("Seleccione un producto para modificar")
            Exit Sub
        End If
        If cboTipoProducto.SelectedIndex <= 0 OrElse cboMarcaProducto.SelectedIndex <= 0 Then
            MostrarError("Seleccione el tipo y la marca del producto")
            Exit Sub
        End If
        Dim precio As Decimal
        If Not Decimal.TryParse(txtPrecio.Text, precio) Then
            MostrarError("Ingrese un precio válido")
            Exit Sub
        End If
        Try
            Dim idMarca As Integer = Convert.ToInt32(cboMarcaProducto.SelectedValue)
            Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
            objProducto.modificarProducto(Convert.ToInt32(txtId.Text), txtNombre.Text.Trim(), Convert.ToInt32(txtStock.Text), chkVigencia.Checked, precio, idTipo, idMarca)
            MostrarExito("PRODUCTO MODIFICADO")
        Catch ex As Exception
            MostrarError("Error al modificar: " & ex.Message)
        End Try
        listar("")
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLimpiar.Click
        limpiar()
        lblMensaje.Text = ""
    End Sub

    Protected Sub btnDarsebaja_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnDarsebaja.Click
        If txtId.Text.Trim() = "" Then
            MostrarError("Escoja un producto para dar de baja")
            Exit Sub
        End If
        Try
            objProducto.darbajaProducto(Convert.ToInt32(txtId.Text))
            MostrarExito("PRODUCTO DADO DE BAJA")
            limpiar()
        Catch ex As Exception
            MostrarError("Error al dar de baja: " & ex.Message)
        End Try
        listar("")
    End Sub

    '====================== SELECCIONAR FILA ======================
    Protected Sub dgvProductos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "Seleccionar" Then
            Try
                Dim id As Integer = Convert.ToInt32(e.CommandArgument)
                Dim fila As DataRow = objProducto.buscarXid(id)
                If fila IsNot Nothing Then
                    txtId.Text = id.ToString()
                    txtNombre.Text = Convert.ToString(fila("producto"))
                    txtStock.Text = Convert.ToString(fila("stock"))
                    chkVigencia.Checked = Convert.ToBoolean(fila("vigencia"))
                    txtPrecio.Text = Convert.ToString(fila("precioactual"))
                    SeleccionarPorTexto(cboMarcaProducto, Convert.ToString(fila("marcaproducto")))
                    SeleccionarPorTexto(cboTipoProducto, Convert.ToString(fila("tipoproducto")))
                    lblMensaje.Text = ""
                End If
            Catch ex As Exception
                MostrarError("Error al seleccionar: " & ex.Message)
            End Try
        End If
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

End Class
