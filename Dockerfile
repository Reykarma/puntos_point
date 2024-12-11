FROM ruby:1.9.3-p551

# Configurar fuentes de Debian archivadas y deshabilitar validación de tiempo
RUN echo "deb http://archive.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated \
    build-essential \
    libpq-dev \
    postgresql-client \
    locales \
    netcat \
    cron && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Configuración de variables de entorno para UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV RAILS_ENV development

WORKDIR /app

# Copiar Gemfile y Gemfile.lock al contenedor
COPY Gemfile Gemfile.lock ./

# Instalar Bundler y gemas
RUN gem install bundler -v 1.17.3 && \
    bundle config set without 'test' && \
    bundle config set frozen 'true' && \
    bundle install --retry=3 --jobs=4

# Copiar el resto de la aplicación
COPY . .

# Configurar cron job para el reporte diario
RUN echo "0 0 * * * cd /app && RAILS_ENV=development bundle exec rake daily_report:send" > /etc/cron.d/daily_report && \
    chmod 0644 /etc/cron.d/daily_report && \
    crontab /etc/cron.d/daily_report

# Exponer el puerto 3000
EXPOSE 3000

# Comando para iniciar cron y Rails
CMD ["bash", "-c", "service cron start && rm -f /app/tmp/pids/server.pid && rails server -b 0.0.0.0"]
