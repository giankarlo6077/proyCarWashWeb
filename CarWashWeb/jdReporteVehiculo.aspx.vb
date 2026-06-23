Imports System.Data
Imports capaNegocio

Partial Class jdReporteVehiculo
    Inherits System.Web.UI.Page

    Dim objReporte As New clsReporteVehiculo()

    ' 1. EVENTO LOAD: Se ejecuta apenas abres la ventana
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            ' Le pasamos un texto vacío para que traiga TODOS los vehículos al inicio
            CargarDatos("")
        End If
    End Sub

    ' 2. EVENTO CLIC: Se ejecuta al presionar la lupa
    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        ' Le pasamos lo que el usuario escribió
        CargarDatos(txtPlaca.Text.Trim())
    End Sub

    ' 3. EVENTO TEXT CHANGED: Detecta cuando la caja de texto queda en blanco
    Protected Sub txtPlaca_TextChanged(sender As Object, e As EventArgs) Handles txtPlaca.TextChanged
        ' Si el usuario borra todo el texto de la caja, cargamos todo de nuevo
        If String.IsNullOrWhiteSpace(txtPlaca.Text) Then
            CargarDatos("")
        End If
    End Sub

    ' 4. MÉTODO AUXILIAR: Centraliza la lógica de llenado de la tabla
    Private Sub CargarDatos(placa As String)
        Try
            ' Obtenemos los datos con la consulta súper poderosa de capaNegocio
            Dim dtHistorial As DataTable = objReporte.ListarHistorial(placa)

            ' Verificamos que el DataTable no sea nulo y tenga filas
            If dtHistorial IsNot Nothing AndAlso dtHistorial.Rows.Count > 0 Then
                ' Llenamos la tabla directamente
                dgvHistorial.DataSource = dtHistorial
                dgvHistorial.DataBind()
                lblMensaje.Text = "" ' Limpiamos errores si todo salió bien
            Else
                ' Si no hay datos, limpiamos la tabla
                dgvHistorial.DataSource = Nothing
                dgvHistorial.DataBind()

                ' Mostramos el mensaje como en tu lógica de escritorio
                If placa <> "" Then
                    MostrarInformacion("No se encontró historial para la placa: " & placa)
                    txtPlaca.Text = ""
                    ' Volvemos a cargar toda la lista para que no quede vacía la pantalla
                    CargarDatos("")
                Else
                    lblMensaje.Text = ""
                End If
            End If

        Catch ex As Exception
            MostrarError("Error del Sistema: " & ex.Message)
        End Try
    End Sub

    ' ================================================================
    ' HELPERS DE MENSAJES (Reemplazo de MessageBox.Show)
    ' ================================================================
    Private Sub MostrarInformacion(mensaje As String)
        lblMensaje.Text = mensaje
        lblMensaje.ForeColor = System.Drawing.Color.DarkOrange ' Un color visible para alertas
    End Sub

    Private Sub MostrarError(mensaje As String)
        lblMensaje.Text = mensaje
        lblMensaje.ForeColor = System.Drawing.Color.Red
    End Sub

End Class