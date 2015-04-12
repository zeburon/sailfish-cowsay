#ifndef SKIN_H
#define SKIN_H

#include <QObject>
#include <QString>
#include <QStringList>

// -----------------------------------------------------------------------

class Skin : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString filename READ getFilename WRITE setFilename NOTIFY signalFilenameChanged)
    Q_PROPERTY(QString text READ getText WRITE setText NOTIFY signalTextChanged)
    Q_PROPERTY(bool supportsEyes READ supportsEyes NOTIFY signalSupportsEyesChanged)
    Q_PROPERTY(bool supportsThreeEyes READ supportsThreeEyes NOTIFY signalSupportsThreeEyesChanged)
    Q_PROPERTY(QString eyes READ getEyes WRITE setEyes NOTIFY signalEyesChanged)
    Q_PROPERTY(bool supportsTongue READ supportsTongue NOTIFY signalSupportsTongueChanged)
    Q_PROPERTY(QString tongue READ getTongue WRITE setTongue NOTIFY signalTongueChanged)
    Q_PROPERTY(bool supportsThinking READ supportsThinking NOTIFY signalSupportsThinkingChanged)
    Q_PROPERTY(bool thinking READ isThinking WRITE setThinking NOTIFY signalThinkingChanged)
    Q_PROPERTY(QString output READ getOutput NOTIFY signalOutputChanged)

public:
    explicit Skin(QObject *parent = 0);
    virtual ~Skin();

    void setFilename(const QString &filename);
    const QString &getFilename() const;
    void setText(const QString &text);
    const QString &getText() const;
    void setEyes(const QString &eyes);
    const QString &getEyes() const;
    bool supportsEyes() const;
    bool supportsThreeEyes() const;
    void setTongue(const QString &tongue);
    const QString &getTongue() const;
    bool supportsTongue() const;
    void setThinking(bool thinking);
    bool isThinking() const;
    bool supportsThinking() const;

    QString getOutput() const;

signals:
    void signalFilenameChanged();
    void signalOutputChanged();
    void signalTextChanged();
    void signalEyesChanged();
    void signalSupportsEyesChanged();
    void signalSupportsThreeEyesChanged();
    void signalTongueChanged();
    void signalSupportsTongueChanged();
    void signalThinkingChanged();
    void signalSupportsThinkingChanged();

private:
    static const QString START_OF_SKIN;
    static const QString END_OF_SKIN;
    static const QString TAG_EYES1;
    static const QString TAG_EYES2;
    static const QString TAG_TONGUE1;
    static const QString TAG_TONGUE2;
    static const QString TAG_THOUGHTS1;
    static const QString TAG_THOUGHTS2;
    static const QString FILENAME_THREE_EYES;

    static const int TEXT_WRAP_LENGTH;
    static const QChar TEXT_WORD_SEPARATOR;
    static const QChar TEXT_BUBBLE_DISABLED;
    static const QChar TEXT_BUBBLE_SAY;
    static const QChar TEXT_BUBBLE_THINK;

    void readFromFile();
    void updateCapabilities();
    void updateTextBubbleString();

    QString m_filename;
    QStringList m_skin_lines;
    QString m_text;
    QString m_text_bubble_string;
    QString m_eyes;
    bool m_supports_eyes;
    QString m_tongue;
    bool m_supports_tongue;
    bool m_thinking;
    bool m_supports_thinking;
    bool m_supports_three_eyes;

};

// -----------------------------------------------------------------------

#endif // SKIN_H
