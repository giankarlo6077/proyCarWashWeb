Imports System.Data
Imports capaNegocio

Partial Class jdGestionarMarca
    Inherits System.Web.UI.Page

    Dim objMarca As New clsMarca()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Protección de sesión
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            btnNuevo.Text = "➕ Nuevo"
            lista()
        End If
    End Sub

    '====================== MÉTODOS DE APOYO ======================
    Private Sub lista()
        Try
            dgvMarcas.DataSource = objMarca.listarMarca()
            dgvMarcas.DataBind()
        Catch ex As Exception
            MostrarError("Error al listar marcas: " & ex.Message)
        End Try
    End Sub

    Private Sub limpiar()
        txtIdMarca.Text = ""
        txtNombre.Text = ""
    End Sub

    '====================== BOTONERA ======================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnBuscar.Click
        If txtIdMarca.Text.Trim() = "" Then
            MostrarError("Ingresa por favor el id para buscar")
            Exit Sub
        End If
        Try
            Dim fila As DataRow = objMarca.buscarXid(Convert.ToInt32(txtIdMarca.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("marcaproducto"))
                lblMensaje.Text = ""
            Else
                MostrarError("No se encontró la marca con ese ID")
            End If
        Catch ex As Exception
            MostrarError("Error al buscar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnNuevo_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnNuevo.Click
        If btnNuevo.Text.Contains("Nuevo") Then
            btnNuevo.Text = "💾 Guardar"
            limpiar()
            MostrarExito("Ingrese el nombre de la marca y presione Guardar.")
        Else
            btnNuevo.Text = "➕ Nuevo"
            If txtNombre.Text.Trim() = "" Then
                MostrarError("Ingrese el nombre de la marca")
                Exit Sub
            End If
            Try
                Dim id As Integer = objMarca.generarCodigoMarca()
                objMarca.registrarMarca(id, txtNombre.Text.Trim())
                MostrarExito("MARCA REGISTRADA")
                lista()
            Catch ex As Exception
                MostrarError("Error al registrar: " & ex.Message)
            End Try
            limpiar()
        End If
    End Sub

    Protected Sub btnModificar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnModificar.Click
        If txtIdMarca.Text.Trim() = "" Then
            MostrarError("Selecciona una marca para modificar")
            Exit Sub
        End If
        Try
            objMarca.modificarMarca(Convert.ToInt32(txtIdMarca.Text), txtNombre.Text.Trim())
            MostrarExito("MARCA MODIFICADA")
            lista()
            limpiar()
        Catch ex As Exception
            MostrarError("Error al modificar: " & ex.Message)
        End Try
    End Sub

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnLimpiar.Click
        limpiar()
        lblMensaje.Text = ""
    End Sub

    Protected Sub btnEliminar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnEliminar.Click
        If txtIdMarca.Text.Trim() = "" Then
            MostrarError("Selecciona una marca para eliminar")
            Exit Sub
        End If
        Try
            objMarca.eliminarMarca(Convert.ToInt32(txtIdMarca.Text))
            MostrarExito("MARCA ELIMINADA")
            lista()
            limpiar()
        Catch ex As Exception
            MostrarError("Error al eliminar: " & ex.Message)
        End Try
    End Sub

    '====================== SELECCIONAR FILA ======================
    Protected Sub dgvMarcas_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "Seleccionar" Then
            Try
                Dim id As Integer = Convert.ToInt32(e.CommandArgument)
                Dim fila As DataRow = objMarca.buscarXid(id)
                If fila IsNot Nothing Then
                    txtIdMarca.Text = id.ToString()
                    txtNombre.Text = Convert.ToString(fila("marcaproducto"))
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
