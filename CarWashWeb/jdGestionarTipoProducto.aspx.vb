Imports System.Data
Imports capaNegocio

Partial Class jdGestionarTipoProducto
    Inherits System.Web.UI.Page

    Dim objTipo As New clsTipoProducto()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            btnNuevo.Text = "➕ Nuevo"
            listar()
        End If
    End Sub

    '====================== MÉTODOS DE APOYO ======================
    Private Sub listar()
        Try
            dgvTipos.DataSource = objTipo.listarTipoProducto()
            dgvTipos.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar tipos de producto: " & ex.Message)
        End Try
    End Sub

    Private Sub limpiar()
        txtIdTipoProducto.Text = ""
        txtNombre.Text = ""
    End Sub

    '====================== BOTONERA ======================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        If txtIdTipoProducto.Text.Trim() = "" Then
            MostrarError("Ingrese el ID para buscar")
            Exit Sub
        End If
        Try
            Dim fila As DataRow = objTipo.buscarXid(Convert.ToInt32(txtIdTipoProducto.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("tipoproducto"))
                lblMensaje.Text = ""
            Else
                MostrarError("No se encontró el tipo de producto con ese ID")
            End If
        Catch ex As Exception
            MostrarError("Error al buscar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnNuevo.Click
        If btnNuevo.Text.Contains("Nuevo") Then
            btnNuevo.Text = "💾 Guardar"
            limpiar()
            MostrarExito("Ingrese el nombre del tipo de producto y presione Guardar.")
        Else
            btnNuevo.Text = "➕ Nuevo"
            If txtNombre.Text.Trim() = "" Then
                MostrarError("Ingrese el nombre del tipo de producto")
                Exit Sub
            End If
            Try
                Dim id As Integer = objTipo.generarCodigoTipoProducto()
                objTipo.registrarTipoProducto(id, txtNombre.Text.Trim())
                MostrarExito("TIPO DE PRODUCTO REGISTRADO")
            Catch ex As Exception
                MostrarError("Error al registrar: " & ex.Message)
            End Try
            limpiar()
            listar()
        End If
    End Sub

    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnModificar.Click
        If txtIdTipoProducto.Text.Trim() = "" Then
            MostrarError("Por favor seleccione un tipo de producto para modificar")
            Exit Sub
        End If
        Try
            objTipo.modificarTipoProducto(Convert.ToInt32(txtIdTipoProducto.Text), txtNombre.Text.Trim())
            MostrarExito("TIPO DE PRODUCTO MODIFICADO")
        Catch ex As Exception
            MostrarError("Error al modificar: " & ex.Message)
        End Try
        limpiar()
        listar()
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLimpiar.Click
        limpiar()
        lblMensaje.Text = ""
    End Sub

    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEliminar.Click
        If txtIdTipoProducto.Text.Trim() = "" Then
            MostrarError("Por favor seleccione un tipo de producto para eliminar")
            Exit Sub
        End If
        Try
            objTipo.eliminarTipoProducto(Convert.ToInt32(txtIdTipoProducto.Text))
            MostrarExito("TIPO DE PRODUCTO ELIMINADO")
        Catch ex As Exception
            MostrarError("Error al eliminar: " & ex.Message)
        End Try
        limpiar()
        listar()
    End Sub

    '====================== SELECCIONAR FILA ======================
    Protected Sub dgvTipos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "Seleccionar" Then
            Try
                Dim id As Integer = Convert.ToInt32(e.CommandArgument)
                Dim fila As DataRow = objTipo.buscarXid(id)
                If fila IsNot Nothing Then
                    txtIdTipoProducto.Text = id.ToString()
                    txtNombre.Text = Convert.ToString(fila("tipoproducto"))
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
