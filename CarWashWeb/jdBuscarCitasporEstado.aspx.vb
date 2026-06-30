Imports System.Data
Imports ServiceReference1

Partial Class jdBuscarCitasporEstado
    Inherits System.Web.UI.Page

    Dim objCita As New WebServiceSoapClient

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

    Protected Sub btnNuevaCita_Click(sender As Object, e As EventArgs) Handles btnNuevaCita.Click
        Response.Redirect("jdGestionarCitas.aspx")
    End Sub
End Class
