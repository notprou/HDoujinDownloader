function Register()

    module.Name = 'MangaTigre'
    module.Language = 'es'

    module.Domains.Add('mangatigre.com')
    module.Domains.Add('www.mangatigre.com')

end

function GetInfo()

    info.Title = dom.Title:beforelast('-')
    info.OriginalTitle = dom.SelectValue('//strong[contains(text(),"Nombre Original")]/following-sibling::text()')
    info.AlternativeTitle = dom.SelectValue('//strong[contains(text(),"Títulos Alternativos")]/following-sibling::*'):split(',')
    info.DateReleased = dom.SelectValue('//strong[contains(text(),"Año")]/following-sibling::text()')
    info.Type = dom.SelectValue('//strong[contains(text(),"Formato")]/following-sibling::a')
    info.Tags = dom.SelectValues('//strong[contains(text(),"Géneros")]/following-sibling::a')
    info.Status = dom.SelectValue('//strong[contains(text(),"Estado")]/following-sibling::text()')
    info.Author = dom.SelectValues('//strong[contains(text(),"Autor(s)")]/following-sibling::a')
    info.Artist = dom.SelectValues('//strong[contains(text(),"Artista(s)")]/following-sibling::a')
    info.Summary = dom.SelectValue('//strong[contains(text(),"Sinopsis")]/following-sibling::text()')

end

function GetChapters()

    -- If there are a lot of chapters, we may need to make an API request.
    -- Make the initial Get request so that we have the required cookies.

    local dom = Dom.New(http.Get(url))
    local loadMoreChaptersButton = dom.SelectElement('//button[contains(@class,"load-more-chapters")]')
    local token = loadMoreChaptersButton.SelectValue('@data-token')
    local endpoint = loadMoreChaptersButton.SelectValue('@data-uri')
  
    if(not isempty(token)) then

        http.Headers['accept'] = '*/*'
        http.Headers['content-type'] = 'application/json'

        dom = Dom.New(http.Post(endpoint, '{"_token":"' .. token .. '"}'))

    end

    chapters.AddRange(dom.SelectElements('//ul[contains(@class,"list-unstyled")]//li/a'))

    chapters.Reverse()

end

function GetPages()

    pages.AddRange(dom.SelectValues('//img[contains(@id,"chapter-image")]/@data-src'))

end
