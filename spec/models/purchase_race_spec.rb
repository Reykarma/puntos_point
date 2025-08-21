# spec/models/purchase_race_spec.rb

if ENV['RAILS_ENV'] == 'test'
  require 'rails_helper'
  require 'concurrent'
  require 'active_job/test_helper'

  RSpec.configure do |c|
    c.use_transactional_fixtures = false
  end

  RSpec.describe 'Race condition en primera compra', type: :model do
    include ActiveJob::TestHelper

    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActiveJob::Base.queue_adapter = :test
      allow_any_instance_of(Product).to receive(:touch).and_return(true)

      ActiveRecord::Base.connection.disable_referential_integrity do
        Purchase.delete_all
        ProductCategory.delete_all
        Product.delete_all
        Client.delete_all
        Category.delete_all
        Admin.delete_all
      end
      clear_enqueued_jobs
      clear_performed_jobs
      ActionMailer::Base.deliveries.clear

      puts "[SETUP] DB limpia, deliveries=#{ActionMailer::Base.deliveries.size}, enqueued=#{enqueued_jobs.size}"
    end

    it 'solo envía un correo de primera compra si dos compras suceden casi a la vez' do
      allow(PurchaseMailer).to receive(:first_purchase_email).and_wrap_original do |_m, product, client|
        puts "[MAIL] first_purchase_email(product_id=#{product.id}, client_id=#{client.id})"
        msg = ActionMailer::Base.mail(
          to: client.email, from: 'noreply@test.local',
          subject: "First purchase for product #{product.id}",
          body: "Client #{client.id}"
        )
        Class.new do
          def initialize(m) = @msg = m
          def deliver_later = @msg.deliver_now
          def deliver_now   = @msg.deliver_now
        end.new(msg)
      end

      # Datos
      admin   = Admin.create!(name: 'Admin', email: "admin_#{SecureRandom.hex(4)}@ex.com", password: '123456')
      product = Product.create!(name: "Prod #{SecureRandom.hex(3)}", price: 100, stock: 100, created_by_id: admin.id)
      category = Category.create!(name: "Cat #{SecureRandom.hex(3)}", created_by_id: admin.id)
      ProductCategory.create!(product: product, category: category)

      client1 = Client.create!(name: 'Juan 1', email: "c1_#{SecureRandom.hex(4)}@test.com", password: 'secret123')
      client2 = Client.create!(name: 'Juan 2', email: "c2_#{SecureRandom.hex(4)}@test.com", password: 'secret123')

      callback_calls = 0
      allow_any_instance_of(Purchase)
        .to receive(:send_first_purchase_email_if_first)
        .and_wrap_original do |m, *args|
          callback_calls += 1
          puts "[CALLBACK] invoked (##{callback_calls})"
          m.call(*args)
        end

      barrier = Concurrent::CyclicBarrier.new(2)

      t1 = Thread.new do
        barrier.wait
        puts "[T1] creando compra"
        Purchase.create!(product: product, client: client1,
                         quantity: 1, total_price: product.price, purchased_at: Time.current)
        puts "[T1] compra creada"
      end

      t2 = Thread.new do
        barrier.wait
        puts "[T2] creando compra"
        Purchase.create!(product: product, client: client2,
                         quantity: 1, total_price: product.price, purchased_at: Time.current)
        puts "[T2] compra creada"
      end

      puts "[JOBS] antes perform: enqueued=#{enqueued_jobs.size}, deliveries=#{ActionMailer::Base.deliveries.size}"
      perform_enqueued_jobs do
        [t1, t2].each { |thr| thr.join(10); raise "Timeout en hilo" if thr.alive? }
      end
      puts "[JOBS] después perform: enqueued=#{enqueued_jobs.size}, deliveries=#{ActionMailer::Base.deliveries.size}"

      total_purchases = Purchase.where(product: product).count
      puts "[CHECK] callback_calls=#{callback_calls}, purchases=#{total_purchases}, deliveries=#{ActionMailer::Base.deliveries.size}"

      expect(callback_calls).to eq(2)
      expect(total_purchases).to eq(2)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
    end
  end

else
  RSpec.describe 'Race condition en primera compra', :skip do
    it 'skipped fuera de test' do
      skip "⏭️ Este spec solo corre en RAILS_ENV=test (actual: #{ENV['RAILS_ENV'].inspect})"
    end
  end
end
