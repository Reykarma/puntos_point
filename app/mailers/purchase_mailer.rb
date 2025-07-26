class PurchaseMailer < ApplicationMailer
  default from: 'test@puntospoint.com'

  def first_purchase_email(product, client)
    @product = product
    @creator = product.creator
    @admins = Admin.where.not(id: @creator.id)
    @client = client

    mail(
      to: @creator.email,
      cc: @admins.pluck(:email),
      subject: "Primera compra del producto: #{@product.name}"
    )
  end
end
