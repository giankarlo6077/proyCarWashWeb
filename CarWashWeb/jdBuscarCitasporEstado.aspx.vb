Imports System.Data
Imports capaNegocio

Partial Class jdBuscarCitasporEstado
    Inherits System.Web.UI.Page

    Dim objCita As New clsCita()

    Private Sub listar(ByVal dato As String)
        Try
            dgvGestion.DataSource = objCita.buscarporEstado(dato)
            dgvGestion.DataBind()
        Catch ex As Exception
            lblMensaje.CssClass = "mensaje-error"
            lblMensaje.Text = "Error al listar mantenimientos por estado: " & ex.Message
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        listar(ddlSexo.SelectedItem.ToString())
    End Sub
End Class
